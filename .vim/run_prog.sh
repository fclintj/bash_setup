#!/bin/bash
main() {
    name=$1
    # get parameters, if available
    for i in $(<params)
    do output+=" $i"
    done 2>/dev/null

    # print running title
    echo  "-------- Running --------"

    # run program based on file extension
    if [[ $1 == *.sh ]]; then
        chmod -x $1
        start=$(date +%s%3N)
        bash $1 $output

    # run program based on file extension
    elif [[ $1 == image_processor.cpp ]]; then
        clear
        echo  "Special:"
        echo  "-------- Building --------"
        make -sC ../../../cmake-build-debug
        if [ $? -eq 0 ] 
        then
            clear
            echo  "Special:"
            echo  "-------- Running ---------"
            start=$(date +%s%3N)
            name=$1
            ../../../cmake-build-debug/camera_array $output
        else
            start=$(date +%s%3N)
            echo "Could not compile" 
        fi 

    elif [[ $1 == *.swift ]]; then
        start=$(date +%s%3N)
        swift $1 $output

    elif [[ $1 == *.launch ]]; then
        start=$(date +%s%3N)
        echo $1

        roslaunch $1

    elif [[ $1 == *.r ]]; then
        start=$(date +%s%3N)
        Rscript $1 $output

    elif [[ $1 == *.cu ]]; then
        start=$(date +%s%3N)
        make
        ./$name $output

    elif [[ $1 == *.cpp || $1 == *.c ]]; then
        clear
        echo  "-------- Building --------"
        make -sC ../build/
        if [ $? -eq 0 ] 
        then
            clear
            echo  "-------- Running ---------"
            ctags -Rf .tags . 
            start=$(date +%s%3N)
            name=$1
            ../build/${name%.*} $output
        else
            start=$(date +%s%3N)
            echo "Could not compile" 
        fi 

    elif [[ $1 == *.py ]]; then
        start=$(date +%s%3N)
        ctags -Rf .tags . 
        python $1 $output

    elif [[ $1 == *.pyx ]]; then
        start=$(date +%s%3N)
        ctags -Rf .tags . 
        tmux send-keys -t 2 "%run $name" C-m

        # cython --embed $1
        # name=$1
        # gcc -I /usr/include/python3.5m -o ${name%.*} ${name%.*}.c -lpython3.5m
        # start=$(date +%s%3N)
        # rm ${name%.*}.c 
        # ./${name%.*} $output 

    elif [[ $1 == *.tex ]]; then
        name=$1
        if [[ ! -d build ]]; then
            mkdir build
        fi
        start=$(date +%s%3N)
        xelatex -output-directory=build $name
        mv build/${name%.*}.pdf ./
        
        # update .bib file if necessary
        bib=$(grep -r -F --include "*.tex" '\cite')

        if [[ $bib != "" ]]; then
            biber ./build/${name%.*}
        fi

        if ps aux | grep okular | grep -v grep 
            then echo
            else
                okular ${name%.*}.pdf &
        fi
    else
        echo Not an executable file type. Edit file ~/.vim/exec.sh
        exit 0
    fi
    
    echo
    echo

    # report run-time
    duration=$(( $(date +%s%3N) - start))
    echo $(return_time $duration)
}

function return_time() {
    hours=$(($1/3600000))
    minutes=$((($1-$hours*3600000)/60000))
    seconds=$(($1%60000))

    echo -en "real:\t"

    if ((hours > 0)); then
        echo -n ${hours}h
    fi
    
    if ((minutes > 0)); then
        echo -n ${minutes}m
    fi
    
    if (($seconds < 1000)); then
        echo -n 0
    fi
    echo $seconds*0.001|bc
    echo -e "\bs"
}


main "$@"
