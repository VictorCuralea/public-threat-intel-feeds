#!/bin/bash

for file in config/*; do
while read -r url; do
  filename=$(basename "$url")
  echo "$url, $filename"
  done < "$file" > "cfg/${file}"
done
