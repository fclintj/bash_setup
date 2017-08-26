#!/bin/bash
echo -e What would you like your new filename to be? \(filename.tex\)
read file_name

if [[ -e ~/.latex/presets/research_paper ]]; then
    cp -r ~/.latex/presets/research_paper/* ./
else
    echo Research paper preset does not exist
    return 0
fi

mv main.tex $file_name
echo Navigate to new file
vim $file_name

