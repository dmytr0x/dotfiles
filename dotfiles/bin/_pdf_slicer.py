# /// script
# requires-python = ">=3.13"
# dependencies = [
#     "pypdf>=5.2.0,<5.3.0",
# ]
# required=True,
# ///

import argparse
import pathlib
import typing

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
    page_ranges = [chunk_to_tuple(chunk) for chunk in chunks.split(",")]

    files: list[ResultItem] = []
    with open(input_path, "rb") as infile:
        reader = pypdf.PdfReader(infile)

        for file_num, (start, stop) in enumerate(page_ranges, start=1):
            writer = pypdf.PdfWriter()
            for page_number in range(start - 1, stop):
                writer.add_page(reader.pages[page_number])

            output_filename = input_path.parent / f"{output_prefix}{file_num:02}.pdf"
            with open(output_filename, "wb") as outfile:
                writer.write(outfile)
                files.append(ResultItem(output_filename.as_posix(), start, stop))

    return files


def display_results(results: list[ResultItem]) -> None:
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
