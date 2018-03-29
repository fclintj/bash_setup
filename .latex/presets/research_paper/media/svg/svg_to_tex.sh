#!/bin/bash

for file in *.svg; do
    name=$(basename "$file" .svg)
    inkscape -D -z --file="$file" --export-pdf="../pdf_tex/$name".pdf --export-latex 
    
    sed -i -e "s/$name.pdf/.\/media\/pdf_tex\/$name.pdf/g" ../pdf_tex/$name.pdf_tex 
done

# to use this application, create an SVG. Save it, and run this script. It will place the pdf and pdf_tex files. 
# Call the function \svg{./media/pdf_tex/title.pdf_tex}{H}{\normalsize}{0.5}{Cap}{fig:}
