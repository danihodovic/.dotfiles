#!usr/bin/env python3
# Taken from
# https://github.com/python-poetry/poetry/issues/663#issuecomment-521011458
import re
import os
from os import path
from pathlib import Path
import sys
import argparse


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "requirements_txt",
        type=str,
        help="Path to the requirements.txt file",
        default="requirements.txt",
        nargs="?",
    )
    args = parser.parse_args()

    requirements_path = Path(args.requirements_txt)

    if not args.requirements_txt.startswith("/"):
        requirements_path = Path(path.join(os.getcwd(), args.requirements_txt))

    pyproject_path = (requirements_path.parent / Path("pyproject.toml")).resolve()

    if not os.path.exists(pyproject_path):
        print(f"No pyproject.toml exists in {pyproject_path}. Run poetry init")
        sys.exit(1)

    with open(requirements_path.resolve()) as f:
        requirements = f.read()

    noComments = re.sub("^#.*$", "", requirements, 0, re.IGNORECASE | re.MULTILINE)
    bareRequirements = re.sub(
        "\n+", "\n", noComments, 0, re.IGNORECASE | re.MULTILINE
    ).strip()

    pipPoetryMap = {">": "^", "=": ""}

    reqList = list()
    for line in bareRequirements.splitlines():
        package, match, version = re.sub(
            r"^(.*?)\s*([~>=<])=\s*v?([0-9\.\*]+)",
            r"\1,\2,\3",
            line,
            0,
            re.IGNORECASE | re.MULTILINE,
        ).split(",")
        try:
            poetryMatch = pipPoetryMap[match]
        except KeyError:
            poetryMatch = match
        poetryLine = f"{package}:{poetryMatch}{version}"
        reqList.append(poetryLine)

    print("Found dependencies:")
    print(reqList)

    for req in reqList:
        os.system(f"poetry add {req}")


if __name__ == "__main__":
    main()
