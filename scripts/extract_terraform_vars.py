#!/usr/bin/env python3
import re
import sys
import os

usage = f"""
Prints all terraform variables in a directory. Used to generate a variables.tf
file based on variables used in resource files (var.foo, var.bar).

Usage:

    ${sys.argv[0]} <directory>
"""

if len(sys.argv) != 2:
    print(usage)
    sys.exit(1)

directory = sys.argv[1]
full_path = os.path.join(os.getcwd(), directory)
files = os.listdir(full_path)


def create_tf_var(var_name):
    return (
        f"""
variable "{var_name}" {{
  type = "string"
}}
"""
        ""
    )


def main():
    already_printed = set()

    for filename in files:
        filepath = os.path.join(full_path, filename)

        with open(filepath, "r") as f:
            for line in f:
                m = re.search(r"var\.(\w+)", line)
                if m:
                    var_name = m.groups()[0]
                    if var_name not in already_printed:
                        print(create_tf_var(var_name))
                        already_printed.add(var_name)


main()
