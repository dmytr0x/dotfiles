#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# ///
"""Symlink or copy shared paths from the primary worktree into a newly created worktree.

Paths missing in the primary worktree are skipped; existing paths in the new worktree
are never overwritten.
"""

import argparse
import shutil
import sys
from collections.abc import Callable
from pathlib import Path

# Paths relative to the repo root.
SHARED_DIRS = [
    ".data",
    ".zed",
]
SHARED_FILES: list[str] = []
# Copied instead of linked, so each worktree gets its own version.
COPIED_DIRS: list[str] = []
COPIED_FILES: list[str] = [
    ".envrc",
]


def copy(src: Path, dst: Path) -> None:
    if src.is_dir():
        shutil.copytree(src, dst, symlinks=True)
    else:
        shutil.copy2(src, dst)


def place(primary: Path, worktree: Path, rel: str, action: Callable[[Path, Path], None], verb: str) -> None:
    src = primary / rel
    dst = worktree / rel
    if not src.exists():
        return
    if dst.exists() or dst.is_symlink():
        print(f"share-paths: kept existing {rel}", file=sys.stderr)
        return
    try:
        dst.parent.mkdir(parents=True, exist_ok=True)
        action(src, dst)
    except OSError as exc:
        print(f"share-paths: {verb} failed: {rel}: {exc}", file=sys.stderr)


def share(primary: Path, worktree: Path) -> None:
    for rel in SHARED_DIRS + SHARED_FILES:
        place(primary, worktree, rel, lambda src, dst: dst.symlink_to(src), "link")
    for rel in COPIED_DIRS + COPIED_FILES:
        place(primary, worktree, rel, copy, "copy")


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Symlink or copy shared paths into a worktree.")
    parser.add_argument("primary", type=Path, help="primary worktree path")
    parser.add_argument("worktree", type=Path, help="newly created worktree path")
    return parser.parse_args(argv)


def main(argv: list[str]) -> int:
    args = parse_args(argv)
    share(args.primary, args.worktree)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
