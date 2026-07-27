#!/usr/bin/env python3
"""Create or synchronize a Herdr session with configured workspaces.

Workspace paths are read from the file passed on the command line, one per
line. Blank lines and lines beginning with "#" are ignored. Relative workspace
paths are resolved from the user's home directory.
"""

import argparse
import json
import os
import re
import subprocess
import sys
import tempfile
import time
from pathlib import Path

HERDR = "herdr"
SESSION_NAME_PATTERN = re.compile(r"[A-Za-z0-9_.-]{1,64}")
SERVER_START_TIMEOUT = 10.0
SERVER_POLL_INTERVAL = 0.1


def run_herdr(*args, session=None, check=True):
    """Run Herdr and return the completed process."""
    command = [HERDR]
    if session is not None:
        command.extend(("--session", session))
    command.extend(args)

    result = subprocess.run(command, text=True, capture_output=True)
    if check and result.returncode != 0:
        details = result.stderr.strip() or result.stdout.strip() or "no output"
        raise RuntimeError(f"{' '.join(command)} failed:\n{details}")

    return result


def run_herdr_json(*args, session=None):
    """Run Herdr and parse its JSON response."""
    result = run_herdr(*args, session=session)
    output = result.stdout.strip()

    try:
        data = json.loads(output)
    except json.JSONDecodeError as exc:
        details = output or result.stderr.strip() or "no output"
        raise RuntimeError(f"Invalid JSON from Herdr:\n{details}") from exc

    if isinstance(data, dict) and "error" in data:
        error = data["error"]
        if isinstance(error, dict):
            code = error.get("code", "herdr_error")
            message = error.get("message", "unknown error")
            raise RuntimeError(f"{code}: {message}")
        raise RuntimeError(f"Herdr error: {error}")

    return data


def read_repositories(config_path: Path):
    """Read, normalize, and validate workspace paths from the config file."""

    if not config_path.is_file():
        raise RuntimeError(
            f"Workspace config not found: {config_path}\n"
            "Create it with one Git repository or directory path per line."
        )

    repositories = []
    seen = set()
    errors = []

    for line_number, line in enumerate(config_path.read_text().splitlines(), 1):
        value = line.strip()
        if not value or value.startswith("#"):
            continue

        path = Path(os.path.expandvars(value)).expanduser()
        if not path.is_absolute():
            path = Path.home() / path
        path = path.resolve()

        if not path.is_dir():
            errors.append(f"line {line_number}: not a directory: {path}")
        elif path not in seen:
            repositories.append(path)
            seen.add(path)

    if errors:
        raise RuntimeError("Invalid workspace config:\n  " + "\n  ".join(errors))
    if not repositories:
        raise RuntimeError(f"No workspaces configured in {config_path}")

    return repositories


def stop_process(process):
    """Stop a server process that failed to start in time."""
    process.terminate()
    try:
        process.wait(timeout=2)
    except subprocess.TimeoutExpired:
        process.kill()
        process.wait()


def ensure_session_running(session):
    """Create or restart a session as needed; return whether it is new."""
    data = run_herdr_json("session", "list", "--json")
    try:
        sessions = data["sessions"]
    except (KeyError, TypeError) as exc:
        raise RuntimeError("Unexpected response from `herdr session list`") from exc

    existing_session = next(
        (item for item in sessions if item.get("name") == session), None
    )
    is_new_session = existing_session is None

    if existing_session and existing_session.get("running"):
        print(f"Using existing Herdr session: {session}")
        return False

    action = "Starting new" if is_new_session else "Restarting"
    print(f"{action} Herdr session: {session}")

    log_path = Path(tempfile.gettempdir()) / f"herdr-{session}.log"
    with log_path.open("w") as log:
        process = subprocess.Popen(
            [HERDR, "--session", session, "server"],
            stdout=log,
            stderr=subprocess.STDOUT,
            start_new_session=True,
        )

        deadline = time.monotonic() + SERVER_START_TIMEOUT
        while time.monotonic() < deadline:
            if process.poll() is not None:
                raise RuntimeError(f"Herdr server exited. See {log_path}")

            result = run_herdr(
                "status", "server", "--json", session=session, check=False
            )
            if result.returncode == 0:
                try:
                    if json.loads(result.stdout).get("running"):
                        return is_new_session
                except (json.JSONDecodeError, AttributeError):
                    pass

            time.sleep(SERVER_POLL_INTERVAL)

        stop_process(process)
        raise RuntimeError(f"Timed out starting Herdr. See {log_path}")


def find_workspace(session, label, checkout_path):
    """Find a workspace by checkout path, falling back to its label."""
    data = run_herdr_json("workspace", "list", session=session)
    try:
        workspaces = data["result"]["workspaces"]
    except (KeyError, TypeError) as exc:
        raise RuntimeError("Unexpected workspace list response") from exc

    for workspace in workspaces:
        path = (workspace.get("worktree") or {}).get("checkout_path")
        if path and Path(path).resolve() == checkout_path:
            return workspace

    return next(
        (workspace for workspace in workspaces if workspace.get("label") == label),
        None,
    )


def workspace_has_cwd(session, workspace_id, expected_cwd):
    """Return whether any pane in a workspace is at the expected directory."""
    data = run_herdr_json(
        "pane", "list", "--workspace", workspace_id, session=session
    )
    try:
        panes = data["result"]["panes"]
    except (KeyError, TypeError) as exc:
        raise RuntimeError(
            f"Unexpected pane list response for workspace {workspace_id}"
        ) from exc

    return any(
        pane.get("cwd") and Path(pane["cwd"]).resolve() == expected_cwd
        for pane in panes
    )


def is_git_worktree_root(path):
    """Return whether path itself is a Git checkout root."""
    # .git is a directory in regular checkouts and a file in linked worktrees
    # and submodules. Do not treat a directory as a repository merely because
    # one of its ancestors contains this entry.
    return (path / ".git").exists()


def open_regular_workspace(session, directory, focus_first=False):
    """Open a regular directory as one Herdr workspace."""
    label = directory.name
    workspace = find_workspace(session, label, directory)
    if workspace:
        workspace_id = workspace["workspace_id"]
        if workspace_has_cwd(session, workspace_id, directory):
            print(f"Already open: {label} ({directory})")
            return 0

        print(f"Reopening workspace with the correct CWD: {label} ({directory})")
        run_herdr_json("workspace", "close", workspace_id, session=session)

    run_herdr_json(
        "workspace",
        "create",
        "--cwd",
        str(directory),
        "--label",
        label,
        "--focus" if focus_first else "--no-focus",
        session=session,
    )
    print(f"Opened workspace: {label} ({directory})")
    return 1


def open_repository_workspaces(session, repository, focus_first=False):
    """Open all worktrees, or one regular workspace, for a directory."""
    if not is_git_worktree_root(repository):
        return open_regular_workspace(session, repository, focus_first=focus_first)

    data = run_herdr_json(
        "worktree", "list", "--cwd", str(repository), "--json", session=session
    )
    try:
        worktrees = data["result"]["worktrees"]
    except (KeyError, TypeError) as exc:
        raise RuntimeError(
            f"Unexpected worktree list response for {repository}"
        ) from exc

    opened = 0
    for worktree in worktrees:
        if worktree.get("is_bare") or worktree.get("is_prunable"):
            continue

        path = Path(worktree["path"]).resolve()
        if path == repository:
            label = repository.name
        else:
            branch = worktree.get("branch") or path.name
            label = branch

        # Query the current workspace list for every worktree. The IDs in the
        # original worktree-list response become stale when a workspace is
        # closed and reopened during this loop.
        workspace = find_workspace(session, label, path)
        if workspace:
            workspace_id = workspace["workspace_id"]
            if workspace_has_cwd(session, workspace_id, path):
                print(f"Already open: {label} ({path})")
                continue

            print(f"Reopening workspace with the correct CWD: {label} ({path})")
            run_herdr_json("workspace", "close", workspace_id, session=session)

        focus = focus_first and opened == 0
        run_herdr_json(
            "worktree",
            "open",
            "--cwd",
            str(repository),
            "--path",
            str(path),
            "--label",
            label,
            "--json",
            "--focus" if focus else "--no-focus",
            session=session,
        )
        print(f"Opened workspace: {label} ({path})")
        opened += 1

    return opened


def session_name(value):
    if not SESSION_NAME_PATTERN.fullmatch(value):
        raise argparse.ArgumentTypeError(
            "must contain only letters, numbers, '.', '_', or '-' (max 64 characters)"
        )
    return value


def repositories_file(value):
    """Expand a repository config path supplied on the command line."""
    return Path(os.path.expandvars(value)).expanduser().resolve()


def parse_args(argv=None):
    parser = argparse.ArgumentParser(
        description="Launch Herdr with all configured Git worktrees and directories."
    )
    parser.add_argument("session", type=session_name, help="Herdr session name")
    parser.add_argument(
        "repositories_file",
        type=repositories_file,
        help="text file containing one Git repository or directory path per line",
    )
    return parser.parse_args(argv)


def main(argv=None):
    args = parse_args(argv)

    try:
        repositories = read_repositories(config_path=args.repositories_file)
        is_new_session = ensure_session_running(args.session)

        # Keep the current focus when adding missing workspaces to an existing
        # session. In a new session, focus the first workspace that is opened.
        workspace_has_focus = not is_new_session
        for repository in repositories:
            opened = open_repository_workspaces(
                args.session,
                repository,
                focus_first=not workspace_has_focus,
            )
            workspace_has_focus = workspace_has_focus or opened > 0

        if os.environ.get("HERDR_ENV"):
            print(
                f"Synchronized Herdr session: {args.session}\n"
                "Already running inside Herdr, so skipping the nested attach."
            )
            return 0

        print(f"Attaching to Herdr session: {args.session}", flush=True)
        os.execvp(HERDR, [HERDR, "session", "attach", args.session])
    except Exception as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
