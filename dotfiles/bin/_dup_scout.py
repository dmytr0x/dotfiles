# /// script
# requires-python = ">=3.13"
# dependencies = []
# ///

import argparse
import hashlib
import pathlib
import shlex
import sys
from collections import Counter, defaultdict
from collections.abc import Generator, Iterable


class Args(argparse.Namespace):
    source: str = ""


def compute_sha(file: pathlib.Path) -> str:
    hasher = hashlib.sha1()
    # INFO: Read file in chunks to handle large files efficiently.
    with file.open("rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            hasher.update(chunk)
    return hasher.hexdigest()


def find_duplicates(files: Iterable[pathlib.Path]) -> Generator[list[pathlib.Path]]:
    duplicates: defaultdict[str, list[pathlib.Path]] = defaultdict(list)
    for file in files:
        sha = compute_sha(file)
        duplicates[sha].append(file)

    counter = Counter({sha: len(files) for sha, files in duplicates.items()})
    for sha, ammount in counter.most_common():
        # INFO: The most_common method is ordered by the counter value,
        #       so we can break the loop immediately after the first value of 1
        if ammount == 1:
            break

        files = duplicates[sha]
        yield files


def traverse(source: pathlib.Path) -> Generator[pathlib.Path]:
    for file in source.rglob("*"):
        if file.is_file():
            yield file


def display_duplicates(dups: Iterable[list[pathlib.Path]]) -> None:
    for n, files in enumerate(dups, start=1):
        print(f"Group {n}:")
        for file in files:
            print(f"  {shlex.quote(file.as_posix())}")
        print()


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Traverse a directory and find duplicate files by SHA-1 hash."
    )
    _ = parser.add_argument(
        "--source",
        type=str,
        required=True,
        help="Directory to traverse for files.",
    )
    args = parser.parse_args(namespace=Args())

    directory = pathlib.Path(args.source)
    if not directory.is_dir():
        print(f"Error: {directory} is not a directory.", file=sys.stderr)
        exit(1)

    display_duplicates(find_duplicates(traverse(directory)))


if __name__ == "__main__":
    main()
