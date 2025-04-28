#!/bin/bash

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <input_directory> <output_directory> [--max_depth N]"
  exit 1
fi

input_dir="$1"
output_dir="$2"
max_depth=""

if [ "$#" -eq 4 ] && [ "$3" = "--max_depth" ]; then
  max_depth="$4"
fi

if [ ! -d "$input_dir" ]; then
  echo "Input directory '$input_dir' does not exist."
  exit 1
fi

if [ ! -d "$output_dir" ]; then
  mkdir -p "$output_dir"
fi

if [ -n "$max_depth" ]; then
  files=$(find "$input_dir" -maxdepth "$max_depth" -type f)
else
  files=$(find "$input_dir" -type f)
fi

for file in $files; do
  filename=$(basename "$file")
  target="$output_dir/$filename"
  
  if [ -e "$target" ]; then
    n=1
    while [ -e "$output_dir/${filename%.*}_$n.${filename##*.}" ]; do
      n=$((n+1))
    done
    target="$output_dir/${filename%.*}_$n.${filename##*.}"
  fi

  cp "$file" "$target"
done



