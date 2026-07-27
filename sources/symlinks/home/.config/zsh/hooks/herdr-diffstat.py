"""Publish colored Git diff stats for all workspaces in local Herdr sessions."""

from __future__ import annotations

import fcntl
import json
import os
import shutil
import subprocess
import tempfile
import time
from pathlib import Path
from typing import Any, TextIO

INTERVAL_SECONDS = 15
EMPTY_SESSION_LIMIT = 4
COMMAND_TIMEOUT_SECONDS = 10
METADATA_SOURCE = "user:git-diffstat"

HERDR = os.environ.get("HERDR_BIN_PATH") or shutil.which("herdr")
GIT = shutil.which("git")
LOCK_PATH = Path(tempfile.gettempdir()) / f"herdr-diffstat-{os.getuid()}.lock"

DiffStat = tuple[int, int, bool]
ServerIdentity = tuple[int, int, int]
Fingerprint = tuple[ServerIdentity, int, int, bool]

# Cache only successful reports. Including the socket identity makes metadata
# get republished after a Herdr server restart, where metadata is not restored.
reported: dict[tuple[str, str], Fingerprint] = {}


def run_json(
    args: list[str], *, socket_path: str | None = None
) -> dict[str, Any] | None:
    """Run a Herdr command and parse its JSON output."""
    if HERDR is None:
        return None

    env = os.environ.copy()
    if socket_path is None:
        env.pop("HERDR_SOCKET_PATH", None)
    else:
        env["HERDR_SOCKET_PATH"] = socket_path

    try:
        result = subprocess.run(
            [HERDR, *args],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
            timeout=COMMAND_TIMEOUT_SECONDS,
            env=env,
        )
        return json.loads(result.stdout)
    except (OSError, subprocess.SubprocessError, json.JSONDecodeError):
        return None


def socket_identity(socket_path: str) -> ServerIdentity | None:
    """Return an identity that changes when a Herdr server replaces its socket."""
    try:
        stat = os.stat(socket_path)
    except OSError:
        return None
    return stat.st_dev, stat.st_ino, stat.st_mtime_ns


def workspace_paths(snapshot: dict[str, Any]) -> list[tuple[str, str]]:
    """Extract each workspace ID and its checkout or initial pane directory."""
    data = snapshot.get("result", {}).get("snapshot", {})

    pane_paths: dict[str, str] = {}
    for pane in data.get("panes", []):
        workspace_id = pane.get("workspace_id")
        cwd = pane.get("cwd")
        if workspace_id and cwd:
            pane_paths.setdefault(workspace_id, cwd)

    workspaces: list[tuple[str, str]] = []
    for workspace in data.get("workspaces", []):
        workspace_id = workspace.get("workspace_id")
        worktree = workspace.get("worktree") or {}
        path = worktree.get("checkout_path") or pane_paths.get(workspace_id)
        if workspace_id and path:
            workspaces.append((workspace_id, path))

    return workspaces


def git_diffstat(path: str) -> DiffStat | None:
    """Return added lines, deleted lines, and whether HEAD has tracked changes."""
    if GIT is None:
        return None

    env = os.environ.copy()
    env["GIT_OPTIONAL_LOCKS"] = "0"
    env["GIT_TERMINAL_PROMPT"] = "0"

    try:
        result = subprocess.run(
            [GIT, "-C", path, "diff", "--numstat", "--no-ext-diff", "HEAD", "--"],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
            timeout=COMMAND_TIMEOUT_SECONDS,
            env=env,
        )
    except (OSError, subprocess.SubprocessError):
        return None

    added = deleted = 0
    changed = False
    for line in result.stdout.splitlines():
        columns = line.split("\t", 2)
        if len(columns) < 2:
            continue
        changed = True
        if columns[0] != "-":
            added += int(columns[0])
        if columns[1] != "-":
            deleted += int(columns[1])

    return added, deleted, changed


def report_diffstat(
    socket_path: str,
    workspace_id: str,
    server_identity: ServerIdentity,
    diffstat: DiffStat,
) -> None:
    """Report changed metadata, or clear it when the workspace is clean."""
    added, deleted, changed = diffstat
    cache_key = socket_path, workspace_id
    fingerprint = server_identity, added, deleted, changed
    if reported.get(cache_key) == fingerprint:
        return

    args = [
        "workspace",
        "report-metadata",
        workspace_id,
        "--source",
        METADATA_SOURCE,
    ]
    if changed:
        args += [
            "--token",
            f"diff_added=+{added}",
            "--token",
            f"diff_deleted=-{deleted}",
        ]
    else:
        args += [
            "--clear-token",
            "diff_added",
            "--clear-token",
            "diff_deleted",
        ]

    # Remove the token used by the earlier single-color implementation.
    args += ["--clear-token", "diffstat"]

    if run_json(args, socket_path=socket_path) is not None:
        reported[cache_key] = fingerprint


def update_session(
    session: dict[str, Any], diffstats: dict[str, DiffStat | None]
) -> None:
    """Update every Git workspace in one running Herdr session."""
    socket_path = session.get("socket_path")
    if not socket_path:
        return

    server_identity = socket_identity(socket_path)
    snapshot = run_json(["api", "snapshot"], socket_path=socket_path)
    if server_identity is None or snapshot is None:
        return

    for workspace_id, path in workspace_paths(snapshot):
        if path not in diffstats:
            diffstats[path] = git_diffstat(path)
        diffstat = diffstats[path]
        if diffstat is not None:
            report_diffstat(socket_path, workspace_id, server_identity, diffstat)


def update_all_sessions() -> bool | None:
    """Update all running local sessions; return whether any are running."""
    response = run_json(["session", "list", "--json"])
    if response is None:
        return None

    sessions = [
        session for session in response.get("sessions", []) if session.get("running")
    ]
    diffstats: dict[str, DiffStat | None] = {}
    for session in sessions:
        update_session(session, diffstats)
    return bool(sessions)


def acquire_singleton_lock() -> TextIO | None:
    """Keep one updater process across all Herdr shells."""
    lock = LOCK_PATH.open("a+")
    try:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        lock.close()
        return None
    return lock


def detach_from_shell() -> None:
    """Detach so closing the Herdr pane that started us does not stop updates."""
    if os.fork() > 0:
        os._exit(0)
    os.setsid()
    if os.fork() > 0:
        os._exit(0)
    os.chdir("/")


def main() -> None:
    if HERDR is None or GIT is None:
        return

    lock = acquire_singleton_lock()
    if lock is None:
        return
    detach_from_shell()

    empty_cycles = 0
    while empty_cycles < EMPTY_SESSION_LIMIT:
        has_running_sessions = update_all_sessions()
        if has_running_sessions is False:
            empty_cycles += 1
        elif has_running_sessions is True:
            empty_cycles = 0

        if empty_cycles < EMPTY_SESSION_LIMIT:
            time.sleep(INTERVAL_SECONDS)

    lock.close()


if __name__ == "__main__":
    main()
