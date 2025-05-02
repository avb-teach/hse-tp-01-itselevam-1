#!/usr/bin/env python3

import os
import shutil
import sys

def copy_all(input_dir, output_dir, max_depth=None):
    if not os.path.isdir(input_dir):
        print(f"Error: '{input_dir}' not found.", file=sys.stderr)
        sys.exit(1)

    os.makedirs(output_dir, exist_ok=True)

    for root, _, files in os.walk(input_dir):
        rel_path = os.path.relpath(root, input_dir)

        if max_depth is None or max_depth <= 0:
            keep_path = ''
        else:
            parts = rel_path.split(os.sep)
            keep_parts = parts[-(max_depth - 1):] if max_depth > 1 else []
            keep_path = os.path.join(*keep_parts) if keep_parts else ''

        for name in files:
            src_file = os.path.join(root, name)
            new_path = os.path.join(output_dir, keep_path, name)
            os.makedirs(os.path.dirname(new_path), exist_ok=True)

            try:
                shutil.copy2(src_file, new_path)
            except Exception as err:
                print(f"Copy error: {src_file} -> {new_path}: {err}", file=sys.stderr)

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} input_dir output_dir [max_depth]")
        sys.exit(1)

    input_dir = sys.argv[1]
    output_dir = sys.argv[2]
    depth_arg = sys.argv[3] if len(sys.argv) > 3 else None

    max_depth = None
    if depth_arg:
        try:
            max_depth = int(depth_arg)
            if max_depth < 1:
                max_depth = None
        except ValueError:
            print("Invalid max_depth", file=sys.stderr)
            sys.exit(1)

    copy_all(input_dir, output_dir, max_depth)


