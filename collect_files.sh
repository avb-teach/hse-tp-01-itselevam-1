#!/usr/bin/env python3

import sys
import os
import shutil

def print_usage():
    print(f"Использование: {sys.argv[0]} <исходная_папка> <папка_назначения> [--max_depth N]")
    sys.exit(1)

def unique_name(dest_dir, filename):
    base, ext = os.path.splitext(filename)
    candidate = filename
    i = 1
    while os.path.exists(os.path.join(dest_dir, candidate)):
        candidate = f"{base}_{i}{ext}"
        i += 1
    return candidate

def main():
    if len(sys.argv) < 3:
        print_usage()

    src = sys.argv[1]
    dst = sys.argv[2]
    max_depth = None

    if len(sys.argv) == 5 and sys.argv[3] == '--max_depth':
        if not sys.argv[4].isdigit():
            print("max_depth должен быть числом")
            sys.exit(1)
        max_depth = int(sys.argv[4])

    if not os.path.isdir(src):
        print(f"Папка {src} не найдена")
        sys.exit(1)

    src = os.path.abspath(src)
    dst = os.path.abspath(dst)

    for root, dirs, files in os.walk(src):
        rel = os.path.relpath(root, src)
        depth = 0 if rel == '.' else rel.count(os.sep) + 1
        if max_depth is not None and depth > max_depth:
            dirs.clear()
            continue

        target_dir = os.path.join(dst, rel) if rel != '.' else dst
        os.makedirs(target_dir, exist_ok=True)

        for f in files:
            src_file = os.path.join(root, f)
            dest_file = unique_name(target_dir, f)
            shutil.copy2(src_file, os.path.join(target_dir, dest_file))

if __name__ == '__main__':
    main()

