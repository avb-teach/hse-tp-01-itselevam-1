#!/bin/bash

if [ "$#" -lt 2 ]; then
  echo "Использование: $0 <папка_с_файлами> <папка_куда_копировать> [--max_depth N]"
  exit 1
fi

input_dir="$1"
output_dir="$2"
max_depth=""

if [ "$#" -eq 4 ] && [ "$3" = "--max_depth" ]; then
  max_depth="$4"
  if ! [[ "$max_depth" =~ ^[0-9]+$ ]]; then
    echo "Ошибка: max_depth должен быть числом"
    exit 1
  fi
fi

input_dir="${input_dir%/}"

if [ ! -d "$input_dir" ]; then
  echo "Папка '$input_dir' не найдена"
  exit 1
fi

mkdir -p "$output_dir"

generate_unique_name() {
  dir="$1"
  filename="$2"
  base="${filename%.*}"
  ext="${filename##*.}"

  if [ "$base" = "$filename" ]; then
    ext=""
  else
    ext=".$ext"
  fi

  target="$dir/$filename"
  n=1

  while [ -e "$target" ]; do
    target="$dir/${base}_$n${ext}"
    n=$((n + 1))
  done

  echo "$target"
}

if [ -n "$max_depth" ]; then
  find_cmd=(find "$input_dir" -maxdepth "$max_depth" -type f)
else
  find_cmd=(find "$input_dir" -type f)
fi

"${find_cmd[@]}" | while IFS= read -r file; do
  rel_path="${file#$input_dir/}"
  rel_dir=$(dirname "$rel_path")

  target_dir="$output_dir/$rel_dir"
  mkdir -p "$target_dir"

  filename=$(basename "$file")

  target=$(generate_unique_name "$target_dir" "$filename")

  cp "$file" "$target"
done
