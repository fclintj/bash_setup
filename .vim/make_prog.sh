#!/bin/bash
# print building banner 
echo  "-------- Building --------"
curr_dir=$(pwd)
name=$1

# build program based on file extension
if [[ $1 == *.sh ]]; then
    chmod -x $1

elif [[ $1 == *.cpp || $1 == *.c ]]; then
    if [[ ! $(find -iname makefile*) ]]
    then
        if [[ $(find ~/.vim/ -maxdepth 1 -iname Makefile ) ]]
        then    
            echo Creating new makefile from ~/.vim/Makefile 
            cp ~/.vim/Makefile "$curr_dir"
            sed -i "s/program/$name/" Makefile 
            sed -i "s/program/${name%.*}/" Makefile 
        else echo Error: No default Makefile found in ~/.vim/
        fi
    else echo Makefile exists
    fi
    make -s

elif [[ $1 == *.py ]]; then
    start=$(date +%s%3N)
    python $1 $output

elif [[ $1 == *.pyx ]]; then
    cython $1
    name=$1
    gcc -Wall -O2 -g -lm -shared -pthread -fPIC -fwrapv -fno-strict-aliasing -I/usr/include/python3.5 -o ${name%.*}.so ${name%.*}.c
    # start=$(date +%s%3N)
    # python3 -c "import ${name%.*}; ${name%.*}.main()"

elif [[ $1 == *.tex ]]; then
    if [[ ! -d build ]]; then
        mkdir build
    fi
    rm build/*

    xelatex -output-directory=build $name
    bibtex build/${name%.*}.aux
    xelatex -output-directory=build $name

    mv build/${name%.*}.pdf ./
    okular ${name%.*}.pdf &

else
    echo Not an executable file type. Edit file ~/.vim/exec.sh
    exit 0
fi

