# /// script
# requires-python = ">=3.13"
# dependencies = [
#     "pypdf>=5.2.0,<5.3.0",
# ]
# ///

import argparse
import pathlib
import typing
from collections.abc import Iterable

import pypdf


class ResultItem(typing.NamedTuple):
    path: str
    page_from: int
    page_to: int


class Args(argparse.Namespace):
    file: str = ""
    prefix: str = ""
    chunks: str = ""


def chunk_to_tuple(chunk: str) -> tuple[int, int]:
    start, end = chunk.strip().split(":")
    return int(start), int(end)


def slice_pdf(
    input_path: pathlib.Path, output_prefix: str, chunks: str
) -> list[ResultItem]:
    results: list[ResultItem] = []

    with input_path.open("rb") as infile:
        reader = pypdf.PdfReader(infile)

        for file_num, (start, stop) in enumerate(
            map(chunk_to_tuple, chunks.split(",")), start=1
        ):
            writer = pypdf.PdfWriter()
            writer.append(reader, pages=(start - 1, stop))

            output_path = input_path.parent / f"{output_prefix}{file_num:02}.pdf"
            with output_path.open("wb") as outfile:
                writer.write(outfile)

            results.append(ResultItem(output_path.as_posix(), start, stop))

    return results


def display_results(results: Iterable[ResultItem]) -> None:
    for item in results:
        print(f"Created: {item.path} with pages from {item.page_from}-{item.page_to}")


def main():
    parser = argparse.ArgumentParser()
    _ = parser.add_argument(
        "-f",
        "--file",
        type=str,
        required=True,
        help="Path to the PDF file",
    )
    _ = parser.add_argument(
        "-p",
        "--prefix",
        type=str,
        required=True,
        help="Prefix of the output PDF files",
    )
    _ = parser.add_argument(
        "-c",
        "--chunks",
        type=str,
        required=True,
        help="Chunks is a string of pairs separated by the comma, e.g.: 20:79,80:99",
    )

    args = parser.parse_args(namespace=Args())

    results = slice_pdf(
        input_path=pathlib.Path(args.file),
        output_prefix=args.prefix,
        chunks=args.chunks,
    )
    display_results(results)


if __name__ == "__main__":
    main()
