#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.13"
# ///

"""Dotfiles manager — install and uninstall symlinks, brewfiles, and scripts."""

import argparse
import shutil
import subprocess
import sys
from enum import StrEnum
from pathlib import Path


class DotfilesPaths:
    @classmethod
    def dotfiles_dir(cls) -> Path:
        return Path(__file__).resolve().parent

    @classmethod
    def sources_dir(cls) -> Path:
        return cls.dotfiles_dir() / "sources"

    @classmethod
    def symlinks_dir(cls) -> Path:
        return cls.sources_dir() / "symlinks"

    @classmethod
    def brewfiles_dir(cls) -> Path:
        return cls.sources_dir() / "brewfiles"

    @classmethod
    def scripts_dir(cls) -> Path:
        return cls.sources_dir() / "scripts"

    @classmethod
    def app_support_dir(cls) -> Path:
        return Path.home() / "Library" / "Application Support"

    @classmethod
    def hammerspoon_dir(cls) -> Path:
        return Path.home() / ".hammerspoon"

    @classmethod
    def local_bin(cls) -> Path:
        return Path.home() / ".local" / "bin"


class Target(StrEnum):
    ALL = "all"
    SYMLINKS = "symlinks"
    BREWFILES = "brewfiles"
    SCRIPTS = "scripts"


def display_path(path: Path) -> str:
    try:
        return str(path.relative_to(DotfilesPaths.dotfiles_dir()))
    except ValueError:
        return str(path)


def print_header(title: str = "") -> None:
    print("-" * 42)
    if title:
        print(title)


def yes_no_question(prompt: str, *, default_yes: bool = True) -> bool:
    options = "Y/n" if default_yes else "y/N"
    while True:
        try:
            answer = input(f"{prompt} [{options}]: ").strip().lower()
        except EOFError:
            print()
            return False
        except KeyboardInterrupt:
            sys.exit(130)
        if answer in {"y", "yes"}:
            return True
        if answer in {"n", "no"}:
            return False
        if answer == "":
            return default_yes
        print("Please answer with yes or no.", file=sys.stderr)


def run(cmd: list[str], **kwargs) -> subprocess.CompletedProcess[str]:
    return subprocess.run(cmd, check=True, **kwargs)


def run_quiet(cmd: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(cmd, check=True, capture_output=True, text=True)


def list_sources(directory: Path, glob_pattern: str) -> list[Path]:
    return sorted(directory.rglob(glob_pattern))


def prepare_symlink_targets() -> None:
    """Handle pre-existing files that would conflict with Stow."""
    # Atuin creates its own config on first run; back it up so Stow can link ours.
    atuin_config = Path.home() / ".config" / "atuin" / "config.toml"
    if atuin_config.is_file() and not atuin_config.is_symlink():
        backup = atuin_config.with_suffix(".toml.backup")
        print(f"Backing up {atuin_config} -> {backup}")
        atuin_config.rename(backup)

    # .local/bin must exists
    DotfilesPaths.local_bin().mkdir(parents=True, exist_ok=True)

    # VS Code needs the target directory to exist for individual file links.
    vscode_dir = DotfilesPaths.app_support_dir() / "Code" / "User"
    vscode_dir.mkdir(parents=True, exist_ok=True)

    # Hammerspoon needs its target directory to exist for Stow to link into.
    DotfilesPaths.hammerspoon_dir().mkdir(parents=True, exist_ok=True)


class SymlinksManager:
    @staticmethod
    def _stow_packages() -> list[tuple[str, Path]]:
        return [
            ("home", Path.home()),
            ("application_support", DotfilesPaths.app_support_dir()),
            (".hammerspoon", DotfilesPaths.hammerspoon_dir()),
        ]

    @staticmethod
    def _require_stow() -> None:
        if shutil.which("stow") is None:
            sys.exit("Error: GNU Stow is not installed.  brew install stow")

    def install(self) -> None:
        self._require_stow()
        self._stow()

    def uninstall(self) -> None:
        self._require_stow()
        self._stow(delete=True)

    @classmethod
    def _stow(cls, *, delete: bool = False) -> None:
        for package, target in cls._stow_packages():
            cmd = [
                "stow",
                f"--dir={DotfilesPaths.symlinks_dir()}",
                f"--target={target}",
                "--verbose",
            ]
            if delete:
                cmd.append("--delete")
            cmd.append(package)
            run(cmd)


class BrewfilesManager:
    @staticmethod
    def _require_brew() -> None:
        if shutil.which("brew") is None:
            sys.exit("Error: Homebrew is not installed.  https://brew.sh")

    def install(self, brewfile: Path) -> None:
        self._require_brew()
        run(["brew", "bundle", "--no-upgrade", f"--file={brewfile}"])

    def uninstall(self, brewfile: Path) -> None:
        self._require_brew()
        for pkg_type in ("formula", "cask"):
            self._uninstall_packages(brewfile, pkg_type)

    @staticmethod
    def show(brewfile: Path, title: str = "") -> None:
        print_header(title)
        text = brewfile.read_text()
        for line in text.splitlines():
            if line.strip() and not line.lstrip().startswith("#"):
                print(line)
        print()

    @staticmethod
    def _uninstall_packages(brewfile: Path, pkg_type: str) -> None:
        try:
            result = run_quiet(
                ["brew", "bundle", "list", f"--{pkg_type}s", f"--file={brewfile}"],
            )
        except subprocess.CalledProcessError:
            return

        for package in result.stdout.splitlines():
            package = package.strip()
            if not package:
                continue
            try:
                run_quiet(["brew", "list", f"--{pkg_type}", package])
            except subprocess.CalledProcessError:
                continue  # not installed
            run(["brew", "uninstall", f"--{pkg_type}", package])


class ScriptsManager:
    def install(self, script: Path) -> None:
        run(["bash", str(script)])


class Dotfiles:
    def __init__(self) -> None:
        self.symlinks = SymlinksManager()
        self.brewfiles = BrewfilesManager()
        self.scripts = ScriptsManager()

    def install(self, target: Target) -> None:
        if target in (Target.ALL, Target.SYMLINKS):
            if yes_no_question("Do you want to install symlinked dotfiles?"):
                prepare_symlink_targets()
                self.symlinks.install()
            if target is not Target.ALL:
                return

        if target in (Target.ALL, Target.BREWFILES):
            for brewfile in list_sources(DotfilesPaths.brewfiles_dir(), "*.Brewfile"):
                self.brewfiles.show(brewfile)
                if yes_no_question(f"Do you want to install {display_path(brewfile)}?"):
                    self.brewfiles.install(brewfile)
            if target is not Target.ALL:
                return

        if target in (Target.ALL, Target.SCRIPTS):
            for script in list_sources(DotfilesPaths.scripts_dir(), "*.sh"):
                print_header(f"Install script: {display_path(script)}")
                print()
                if yes_no_question(f"Do you want to run {display_path(script)}?"):
                    self.scripts.install(script)
            if target is not Target.ALL:
                return

    def uninstall(self, target: Target) -> None:
        if target in (Target.ALL, Target.SYMLINKS):
            if yes_no_question("Do you want to uninstall symlinked dotfiles?"):
                self.symlinks.uninstall()
            if target is not Target.ALL:
                return

        if target in (Target.ALL, Target.BREWFILES):
            if target is Target.ALL and not yes_no_question(
                "Do you want to uninstall Homebrew packages from all Brewfiles?",
                default_yes=False,
            ):
                return
            for brewfile in list_sources(DotfilesPaths.brewfiles_dir(), "*.Brewfile"):
                self.brewfiles.show(
                    brewfile, f"Uninstalling dependencies from {display_path(brewfile)}"
                )
                self.brewfiles.uninstall(brewfile)
            if target is not Target.ALL:
                return

        if target is Target.SCRIPTS:
            print("Scripts support only the install action.", file=sys.stderr)
            return


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="dotfiles",
        description="Install or uninstall personal dotfiles.",
    )
    subparsers = parser.add_subparsers(dest="action", required=True)

    install = subparsers.add_parser("install", help="Install dotfiles.")
    install.add_argument(
        "target",
        nargs="?",
        default=Target.ALL,
        type=parse_target,
        metavar="TARGET",
        help="What to install: symlinks, brewfiles, scripts, or omit for all.",
    )

    uninstall = subparsers.add_parser("uninstall", help="Uninstall dotfiles.")
    uninstall.add_argument(
        "target",
        nargs="?",
        default=Target.ALL,
        type=parse_target,
        metavar="TARGET",
        help="What to uninstall: symlinks, brewfiles, scripts, or omit for all.",
    )

    return parser


def parse_target(value: str) -> Target:
    try:
        return Target(value.lower())
    except ValueError as error:
        choices = ", ".join(target.value for target in Target)
        raise argparse.ArgumentTypeError(
            f"Invalid target '{value}'. Choose one of: {choices}."
        ) from error


def main(argv: list[str] | None = None) -> None:
    args = build_parser().parse_args(argv)
    dotfiles = Dotfiles()

    if args.action == "install":
        dotfiles.install(args.target)
    else:
        dotfiles.uninstall(args.target)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(130)
