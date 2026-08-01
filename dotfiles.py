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

import tomllib

DOTFILES_DIR = Path(__file__).resolve().parent
SOURCES_DIR = DOTFILES_DIR / "sources"
SYMLINKS_DIR = SOURCES_DIR / "symlinks"
SYMLINKS_MANIFEST = SOURCES_DIR / "symlinks.toml"
BREWFILES_DIR = SOURCES_DIR / "brewfiles"
SCRIPTS_DIR = SOURCES_DIR / "scripts"


class Target(StrEnum):
    ALL = "all"
    SYMLINKS = "symlinks"
    BREWFILES = "brewfiles"
    SCRIPTS = "scripts"


def display_path(path: Path) -> str:
    try:
        return str(path.relative_to(DOTFILES_DIR))
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


def require_command(command: str, message: str) -> None:
    if shutil.which(command) is None:
        sys.exit(f"Error: {message}")


class SymlinksManager:
    @staticmethod
    def _stow_packages() -> dict[str, Path]:
        home = Path.home()
        return {
            "home": home,
            "application_support": home / "Library" / "Application Support",
            ".hammerspoon": home / ".hammerspoon",
        }

    def install(self) -> None:
        require_command("stow", "GNU Stow is not installed.  brew install stow")
        self._prepare_targets()
        self._stow()

    def uninstall(self) -> None:
        require_command("stow", "GNU Stow is not installed.  brew install stow")
        self._stow(delete=True)

    @staticmethod
    def _manifest_target_directories() -> list[Path]:
        with SYMLINKS_MANIFEST.open("rb") as manifest_file:
            manifest = tomllib.load(manifest_file)

        unknown_keys = manifest.keys() - {"target_directories"}
        if unknown_keys:
            unknown = ", ".join(sorted(unknown_keys))
            raise ValueError(f"Unknown keys in {SYMLINKS_MANIFEST}: {unknown}")

        paths = manifest.get("target_directories", [])
        if not isinstance(paths, list) or not all(
            isinstance(path, str) for path in paths
        ):
            raise ValueError(
                f"target_directories in {SYMLINKS_MANIFEST} must be a list of paths"
            )
        return [Path(path) for path in paths]

    @classmethod
    def _source_and_target(cls, relative_path: Path) -> tuple[Path, Path]:
        parts = relative_path.parts
        if relative_path.is_absolute() or not parts or ".." in parts:
            raise ValueError(f"Invalid symlink manifest path: {relative_path}")

        package_targets = cls._stow_packages()
        package = parts[0]
        if package not in package_targets:
            raise ValueError(f"Unknown Stow package in manifest: {relative_path}")

        source = SYMLINKS_DIR / relative_path
        target = package_targets[package].joinpath(*parts[1:])
        return source, target

    @staticmethod
    def _backup_path(path: Path) -> Path:
        backup = path.with_name(f"{path.name}.backup")
        number = 1
        while backup.exists() or backup.is_symlink():
            backup = path.with_name(f"{path.name}.backup.{number}")
            number += 1
        return backup

    @classmethod
    def _backup_conflict(cls, target: Path, source: Path) -> None:
        if not target.exists() and not target.is_symlink():
            return
        if target.resolve(strict=False) == source.resolve(strict=False):
            return

        backup = cls._backup_path(target)
        print(f"Backing up {target} -> {backup}")
        target.rename(backup)

    @classmethod
    def _prepare_directory(
        cls,
        source_directory: Path,
        target_directory: Path,
        target_directories: set[Path],
    ) -> None:
        for source in source_directory.iterdir():
            target = target_directory / source.name
            contains_target_directory = any(
                directory.is_relative_to(source) for directory in target_directories
            )
            if source.is_dir() and contains_target_directory:
                cls._prepare_directory(source, target, target_directories)
            else:
                cls._backup_conflict(target, source)

    @classmethod
    def _prepare_targets(cls) -> None:
        target_directories: set[Path] = set()

        for path in cls._manifest_target_directories():
            source, target = cls._source_and_target(path)
            if not source.is_dir():
                raise ValueError(f"Target directory source does not exist: {source}")
            target_directories.add(source)

            if target.exists() and not target.is_dir():
                cls._backup_conflict(target, source)
            target.mkdir(parents=True, exist_ok=True)

        for package, package_target in cls._stow_packages().items():
            package_source = SYMLINKS_DIR / package
            package_target.mkdir(parents=True, exist_ok=True)
            cls._prepare_directory(package_source, package_target, target_directories)

    @classmethod
    def _stow(cls, *, delete: bool = False) -> None:
        for package, target in cls._stow_packages().items():
            cmd = [
                "stow",
                f"--dir={SYMLINKS_DIR}",
                f"--target={target}",
                "--verbose",
            ]
            if delete:
                cmd.append("--delete")
            cmd.append(package)
            run(cmd)


class BrewfilesManager:
    def install(self, brewfile: Path) -> None:
        require_command("brew", "Homebrew is not installed.  https://brew.sh")
        run(["brew", "bundle", "--no-upgrade", f"--file={brewfile}"])

    def uninstall(self, brewfile: Path) -> None:
        require_command("brew", "Homebrew is not installed.  https://brew.sh")
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
        if target in (Target.ALL, Target.SYMLINKS) and yes_no_question(
            "Do you want to install symlinked dotfiles?"
        ):
            self.symlinks.install()

        if target in (Target.ALL, Target.BREWFILES):
            for brewfile in list_sources(BREWFILES_DIR, "*.Brewfile"):
                self.brewfiles.show(brewfile)
                if yes_no_question(f"Do you want to install {display_path(brewfile)}?"):
                    self.brewfiles.install(brewfile)

        if target in (Target.ALL, Target.SCRIPTS):
            for script in list_sources(SCRIPTS_DIR, "*.sh"):
                print_header(f"Install script: {display_path(script)}")
                print()
                if yes_no_question(f"Do you want to run {display_path(script)}?"):
                    self.scripts.install(script)

    def uninstall(self, target: Target) -> None:
        if target in (Target.ALL, Target.SYMLINKS) and yes_no_question(
            "Do you want to uninstall symlinked dotfiles?"
        ):
            self.symlinks.uninstall()

        if target in (Target.ALL, Target.BREWFILES):
            if target is Target.ALL and not yes_no_question(
                "Do you want to uninstall Homebrew packages from all Brewfiles?",
                default_yes=False,
            ):
                return
            for brewfile in list_sources(BREWFILES_DIR, "*.Brewfile"):
                self.brewfiles.show(
                    brewfile, f"Uninstalling dependencies from {display_path(brewfile)}"
                )
                self.brewfiles.uninstall(brewfile)

        if target is Target.SCRIPTS:
            print("Scripts support only the install action.", file=sys.stderr)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="dotfiles",
        description="Install or uninstall personal dotfiles.",
    )
    subparsers = parser.add_subparsers(dest="action", required=True)

    for action in ("install", "uninstall"):
        command = subparsers.add_parser(action, help=f"{action.title()} dotfiles.")
        command.add_argument(
            "target",
            nargs="?",
            default=Target.ALL,
            type=parse_target,
            metavar="TARGET",
            help=f"What to {action}: symlinks, brewfiles, scripts, or omit for all.",
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
