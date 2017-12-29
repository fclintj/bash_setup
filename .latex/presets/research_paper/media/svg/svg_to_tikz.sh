#!/bin/bash

for file in *.svg; do
    name=$(basename "$file" .svg)
    inkscape -D -z --file="$file" --export-pdf="$name".pdf --export-latex 
    rm "$name".pdf
done
