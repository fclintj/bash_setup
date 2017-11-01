#!/bin/bash
# print building banner 
echo  "-------- Building --------"
curr_dir=$(pwd)
name=$1

# build program based on file extension
if [[ $1 == *.sh ]]; then
    chmod -x $1

elif [[ $1 == *.cpp || $1 == *.c ]]; then
    if [[ ! -d ../source ]]; then
        mkdir source
        mv $name source
        mkdir build
        cd source
        curr_dir+=/source
    fi

    if [[ ! -d ../build ]]; then
        mkdir ../build
    fi

    rm -fr ../build/* 

    if [[ ! -e CMakeLists.txt ]]; then
        if [[ -e ~/.vim/CMakeLists.txt  ]]; then
            echo Creating new CMakeLists.txt from ~/.vim/CMakeLists.txt 
            cp ~/.vim/CMakeLists.txt "$curr_dir"
            sed -i "s/project_name/${name%.*}/" CMakeLists.txt 
            sed -i "s/file_name/$name/" CMakeLists.txt 
        else echo Error: No default CMakeLists found in ~/.vim/
        fi
    else echo CMakeLists already exists
    fi
    cd ../build    
    cmake ../source
    make

elif [[ $1 == *.py ]]; then
    ctags -Rf .tags . 
    start=$(date +%s%3N)
    python $1 $output

elif [[ $1 == *.pyx ]]; then
    cython --embed $1
    ctags -Rf .tags . 
    name=$1
    gcc -I /usr/include/python3.5m -o ${name%.*} ${name%.*}.c -lpython3.5m
    start=$(date +%s%3N)
    rm ${name%.*}.c 
    ./${name%.*} $output 

    # cython $1 
    # name=$1
    # gcc -Wall -O2 -g -lm -shared -pthread -fPIC -fwrapv -fno-strict-aliasing -I/usr/include/python3.5 -o ${name%.*}.so ${name%.*}.c
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

