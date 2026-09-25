#!/usr/bin/env python3
"""Attach to a Herdr layout and send a message to an agent CLI."""

from __future__ import annotations

import argparse
import json
import os
import shlex
import shutil
import subprocess
import sys
import time
from typing import Any

DEFAULT_HARNESS = "claude"
AGENT_NAME_PREFIX = "zed"
SERVER_WAIT_SECONDS = 15.0
SHELL_READY_WAIT_SECONDS = 15.0
SHELL_READY_POLL_SECONDS = 0.2
DEFAULT_TAB_LABELS = {"", "1"}
AGENT_PANE_BUSY = "agent_pane_busy"
AGENT_NAME_PATTERN_MAX = 32


class HerdrError(RuntimeError):
    def __init__(self, message: str, code: str | None = None) -> None:
        super().__init__(message)
        self.code = code


def herdr_bin() -> str:
    path = shutil.which("herdr")
    if not path:
        raise HerdrError("herdr is not on PATH")
    return path


def known_agent_kinds() -> list[str]:
    proc = subprocess.run(
        [herdr_bin(), "agent", "start", "--help"],
        capture_output=True,
        text=True,
    )
    text = f"{proc.stdout}\n{proc.stderr}"
    marker = "[possible values:"
    start = text.find(marker)
    if start == -1:
        return []
    rest = text[start + len(marker) :]
    end = rest.find("]")
    if end == -1:
        return []
    return [item.strip() for item in rest[:end].split(",") if item.strip()]


def parse_harness(value: str) -> tuple[str, list[str]]:
    parts = shlex.split(value)
    if not parts:
        raise HerdrError("--harness is empty")
    kind = os.path.basename(parts[0]).lower()
    extra = parts[1:]
    kinds = known_agent_kinds()
    if kinds and kind not in kinds:
        raise HerdrError(
            f"unknown harness {kind!r}; herdr --kind values: {', '.join(kinds)}"
        )
    return kind, extra


def format_harness(kind: str, extra: list[str]) -> str:
    return shlex.join([kind, *extra])


def agent_name_base(kind: str) -> str:
    base = f"{AGENT_NAME_PREFIX}-{kind}"
    if len(base) <= AGENT_NAME_PATTERN_MAX:
        return base
    return base[:AGENT_NAME_PATTERN_MAX]


def run_herdr(session: str, *args: str) -> subprocess.CompletedProcess[str]:
    cmd = [herdr_bin(), "--session", session, *args]
    return subprocess.run(cmd, capture_output=True, text=True)


def parse_payload(proc: subprocess.CompletedProcess[str]) -> Any | None:
    payload = (proc.stdout or "").strip() or (proc.stderr or "").strip()
    if not payload:
        if proc.returncode == 0:
            return None
        raise HerdrError(
            proc.stderr.strip() or proc.stdout.strip() or f"herdr exited {proc.returncode}"
        )
    try:
        data = json.loads(payload)
    except json.JSONDecodeError:
        if proc.returncode == 0:
            return payload
        raise HerdrError(payload) from None
    if isinstance(data, dict) and data.get("error"):
        error = data["error"]
        raise HerdrError(error.get("message") or payload, code=error.get("code"))
    if proc.returncode != 0:
        raise HerdrError(payload)
    return data


def herdr(session: str, *args: str) -> Any | None:
    return parse_payload(run_herdr(session, *args))


def result(data: Any) -> dict[str, Any]:
    if not isinstance(data, dict):
        raise HerdrError(f"unexpected herdr response: {data!r}")
    payload = data.get("result")
    if not isinstance(payload, dict):
        raise HerdrError(f"unexpected herdr result: {data!r}")
    return payload


def session_running(session: str) -> bool:
    proc = run_herdr(session, "status", "server")
    text = (proc.stdout or "") + (proc.stderr or "")
    return proc.returncode == 0 and "status: running" in text


def ensure_session(session: str) -> None:
    if session_running(session):
        return
    subprocess.Popen(
        [herdr_bin(), "--session", session, "server"],
        stdin=subprocess.DEVNULL,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        start_new_session=True,
    )
    deadline = time.monotonic() + SERVER_WAIT_SECONDS
    while time.monotonic() < deadline:
        if session_running(session):
            return
        time.sleep(0.2)
    raise HerdrError(
        f"could not start herdr session {session!r}; "
        f"run `herdr session attach {session}` and retry"
    )


def list_items(session: str, *args: str, key: str) -> list[dict[str, Any]]:
    items = result(herdr(session, *args)).get(key) or []
    if not isinstance(items, list):
        raise HerdrError(f"unexpected herdr {key} list: {items!r}")
    return [item for item in items if isinstance(item, dict)]


def find_by_label(
    items: list[dict[str, Any]], label: str, extra: dict[str, Any] | None = None
) -> dict[str, Any] | None:
    extra = extra or {}
    for item in items:
        if item.get("label") != label:
            continue
        if all(item.get(key) == value for key, value in extra.items()):
            return item
    return None


def same_path(left: str, right: str) -> bool:
    return os.path.realpath(left) == os.path.realpath(right)


def workspace_id_from(payload: dict[str, Any]) -> str:
    workspace = payload.get("workspace")
    if isinstance(workspace, dict) and workspace.get("workspace_id"):
        return str(workspace["workspace_id"])
    if payload.get("workspace_id"):
        return str(payload["workspace_id"])
    raise HerdrError(f"missing workspace_id in herdr response: {payload!r}")


def worktree_list_payload(session: str, cwd: str) -> dict[str, Any] | None:
    try:
        return result(herdr(session, "worktree", "list", "--cwd", cwd))
    except HerdrError:
        return None


def match_worktree(payload: dict[str, Any] | None, cwd: str) -> dict[str, Any] | None:
    if not payload:
        return None
    worktrees = payload.get("worktrees") or []
    if not isinstance(worktrees, list):
        return None
    for worktree in worktrees:
        if isinstance(worktree, dict) and same_path(str(worktree.get("path") or ""), cwd):
            return worktree
    return None


def parent_repo_cwd(payload: dict[str, Any], worktree: dict[str, Any], cwd: str) -> str:
    source = payload.get("source")
    if isinstance(source, dict):
        for key in ("source_checkout_path", "repo_root"):
            value = str(source.get(key) or "")
            if value:
                return os.path.realpath(value)
    if worktree.get("is_linked_worktree"):
        raise HerdrError(
            "worktree list did not include the repo parent path needed to open "
            f"{cwd}"
        )
    return cwd


def find_workspace_by_path(session: str, cwd: str) -> str | None:
    worktree = match_worktree(worktree_list_payload(session, cwd), cwd)
    if worktree and worktree.get("open_workspace_id"):
        return str(worktree["open_workspace_id"])
    for workspace in list_items(session, "workspace", "list", key="workspaces"):
        checkout = str((workspace.get("worktree") or {}).get("checkout_path") or "")
        if checkout and same_path(checkout, cwd):
            return str(workspace["workspace_id"])
    return None


def ensure_workspace(session: str, cwd: str) -> str:
    workspace_id = find_workspace_by_path(session, cwd)
    if workspace_id:
        return workspace_id

    payload = worktree_list_payload(session, cwd)
    worktree = match_worktree(payload, cwd)
    if payload is not None and worktree is not None:
        parent = parent_repo_cwd(payload, worktree, cwd)
        opened = result(
            herdr(
                session,
                "worktree",
                "open",
                "--cwd",
                parent,
                "--path",
                cwd,
                "--no-focus",
            )
        )
        return workspace_id_from(opened)

    created = result(herdr(session, "workspace", "create", "--cwd", cwd, "--no-focus"))
    return workspace_id_from(created)


def tab_panes(session: str, workspace_id: str, tab_id: str) -> list[dict[str, Any]]:
    return [
        pane
        for pane in list_items(
            session, "pane", "list", "--workspace", workspace_id, key="panes"
        )
        if pane.get("tab_id") == tab_id
    ]


def rename_pane(session: str, pane_id: str, pane_label: str) -> str:
    herdr(session, "pane", "rename", pane_id, pane_label)
    return pane_id


def ensure_main_pane(
    session: str,
    workspace_id: str,
    tab_id: str,
    cwd: str,
    tab_label: str,
    pane_label: str,
) -> str:
    panes = tab_panes(session, workspace_id, tab_id)
    pane = find_by_label(panes, pane_label)
    if pane is not None:
        return str(pane["pane_id"])
    if len(panes) == 1 and not panes[0].get("label"):
        return rename_pane(session, str(panes[0]["pane_id"]), pane_label)
    if not panes:
        raise HerdrError(f"tab {tab_label!r} ({tab_id}) has no panes to split")
    created = result(
        herdr(
            session,
            "pane",
            "split",
            str(panes[0]["pane_id"]),
            "--direction",
            "right",
            "--cwd",
            cwd,
            "--no-focus",
        )
    )
    pane_id = str((created.get("pane") or {})["pane_id"])
    return rename_pane(session, pane_id, pane_label)


def ensure_tab_and_pane(
    session: str,
    workspace_id: str,
    cwd: str,
    tab_label: str,
    pane_label: str,
) -> tuple[str, str]:
    tabs = list_items(
        session, "tab", "list", "--workspace", workspace_id, key="tabs"
    )
    tab = find_by_label(tabs, tab_label)
    if tab is None and len(tabs) == 1:
        existing_label = str(tabs[0].get("label") or "")
        if existing_label in DEFAULT_TAB_LABELS:
            tab_id = str(tabs[0]["tab_id"])
            herdr(session, "tab", "rename", tab_id, tab_label)
            pane_id = ensure_main_pane(
                session, workspace_id, tab_id, cwd, tab_label, pane_label
            )
            return tab_id, pane_id
    if tab is None:
        created = result(
            herdr(
                session,
                "tab",
                "create",
                "--workspace",
                workspace_id,
                "--cwd",
                cwd,
                "--label",
                tab_label,
                "--no-focus",
            )
        )
        tab_id = str((created.get("tab") or {})["tab_id"])
        pane_id = str((created.get("root_pane") or {})["pane_id"])
        return tab_id, rename_pane(session, pane_id, pane_label)

    tab_id = str(tab["tab_id"])
    return tab_id, ensure_main_pane(
        session, workspace_id, tab_id, cwd, tab_label, pane_label
    )


def process_mentions_kind(process: dict[str, Any], kind: str) -> bool:
    tokens: list[str] = []
    for key in ("name", "argv0", "cmdline"):
        value = str(process.get(key) or "").strip()
        if not value:
            continue
        try:
            tokens.extend(shlex.split(value))
        except ValueError:
            tokens.append(value)
    tokens.extend(str(part) for part in process.get("argv") or [])
    kind_l = kind.lower()
    for token in tokens:
        base = os.path.basename(token).lower()
        if base == kind_l or base.startswith(f"{kind_l}-") or base.startswith(f"{kind_l}."):
            return True
    return False


def pane_detected_kind(session: str, pane_id: str) -> str | None:
    pane = result(herdr(session, "pane", "get", pane_id)).get("pane") or {}
    agent = pane.get("agent")
    return str(agent) if agent else None


def pane_has_agent(session: str, pane_id: str, kind: str) -> bool:
    if pane_detected_kind(session, pane_id) == kind:
        return True
    info = result(herdr(session, "pane", "process-info", "--pane", pane_id))
    processes = (info.get("process_info") or {}).get("foreground_processes") or []
    return any(
        isinstance(process, dict) and process_mentions_kind(process, kind)
        for process in processes
    )


def unique_agent_name(session: str, kind: str) -> str:
    taken = {
        agent.get("name")
        for agent in list_items(session, "agent", "list", key="agents")
        if agent.get("name")
    }
    base = agent_name_base(kind)
    if base not in taken:
        return base
    for index in range(2, 100):
        suffix = f"-{index}"
        candidate = f"{base[: AGENT_NAME_PATTERN_MAX - len(suffix)]}{suffix}"
        if candidate not in taken:
            return candidate
    raise HerdrError("could not allocate a unique herdr agent name")


def ensure_agent(
    session: str, pane_id: str, kind: str, extra: list[str]
) -> str:
    detected = pane_detected_kind(session, pane_id)
    if detected == kind:
        return "already-running"
    if detected:
        raise HerdrError(
            f"pane already has agent {detected!r}; requested {kind!r}"
        )
    if pane_has_agent(session, pane_id, kind):
        return "already-running"
    name = unique_agent_name(session, kind)
    start_args = [
        "agent",
        "start",
        name,
        "--kind",
        kind,
        "--pane",
        pane_id,
    ]
    if extra:
        start_args.extend(["--", *extra])
    deadline = time.monotonic() + SHELL_READY_WAIT_SECONDS
    while True:
        try:
            herdr(session, *start_args)
            return f"started:{name}"
        except HerdrError as exc:
            if exc.code == "agent_not_ready" and pane_has_agent(session, pane_id, kind):
                return f"started-blocked:{name}"
            if exc.code != AGENT_PANE_BUSY:
                raise
            if pane_has_agent(session, pane_id, kind):
                return "already-running"
            if time.monotonic() >= deadline:
                raise
            time.sleep(SHELL_READY_POLL_SECONDS)


def send_message(
    session: str, pane_id: str, message: str, auto_submit: bool, kind: str
) -> str:
    if auto_submit:
        if pane_detected_kind(session, pane_id) == kind:
            try:
                herdr(session, "agent", "prompt", pane_id, message)
                return "submitted"
            except HerdrError as exc:
                if exc.code not in {"agent_blocked", "agent_not_ready"}:
                    raise
        herdr(session, "pane", "send-text", pane_id, message)
        herdr(session, "pane", "send-keys", pane_id, "enter")
        return "submitted"
    herdr(session, "pane", "send-text", pane_id, message)
    return "pending"


def run(
    session: str,
    worktree: str,
    tab_label: str,
    pane_label: str,
    message: str,
    auto_submit: bool,
    kind: str,
    extra: list[str],
) -> int:
    cwd = os.path.realpath(worktree)
    if not os.path.isdir(cwd):
        raise HerdrError(f"worktree does not exist: {cwd}")
    ensure_session(session)
    workspace_id = ensure_workspace(session, cwd)
    tab_id, pane_id = ensure_tab_and_pane(
        session, workspace_id, cwd, tab_label, pane_label
    )
    agent_state = ensure_agent(session, pane_id, kind, extra)
    send_state = send_message(session, pane_id, message, auto_submit, kind)
    herdr(session, "workspace", "focus", workspace_id)
    herdr(session, "tab", "focus", tab_id)
    lines = [
        f"session={session}",
        f"workspace={workspace_id} ({cwd})",
        f"tab={tab_id} ({tab_label})",
        f"pane={pane_id} ({pane_label})",
        f"harness={format_harness(kind, extra)}",
        f"agent={agent_state}",
        f"send={send_state}",
        f"sent={message}",
    ]
    if agent_state == "already-running" and extra:
        lines.append(
            f"note=harness args not applied; pane already has {kind}"
        )
    print("\n".join(lines))
    return 0


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Attach to a Herdr session/workspace/tab/pane and send text to an agent CLI."
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=(
            "The first token of --harness is Herdr's --kind (claude, cursor, pi, …). "
            "Any remaining tokens are passed after `--` to that executable.\n"
            "\n"
            "Quote the value so this script does not eat agent flags:\n"
            "  --harness='claude --model=opus --permission-mode=auto --effort medium'\n"
            "  --harness=cursor\n"
        ),
    )
    parser.add_argument("--session", required=True, help="Herdr session name")
    parser.add_argument(
        "--worktree",
        required=True,
        help="Worktree path to attach to or open",
    )
    parser.add_argument("--tab-label", required=True, help="Tab label to attach to")
    parser.add_argument("--pane-label", required=True, help="Pane label to attach to")
    parser.add_argument("--message", required=True, help="Text to send to the agent CLI")
    parser.add_argument(
        "--harness",
        default=DEFAULT_HARNESS,
        help=(
            "Agent to run in the pane. First token is the Herdr kind; the rest "
            "are native agent args. Default: %(default)s"
        ),
    )
    parser.add_argument(
        "--auto-submit",
        action="store_true",
        help="Submit the message immediately; omit to leave it in the agent input",
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    try:
        kind, extra = parse_harness(args.harness)
        return run(
            args.session,
            args.worktree,
            args.tab_label,
            args.pane_label,
            args.message,
            args.auto_submit,
            kind,
            extra,
        )
    except HerdrError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
