#!/bin/bash
main() 
{
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

    elif [[ $1 == *.swift ]]; then
        start=$(date +%s%3N)
        swift $1 $output

    elif [[ $1 == *.cpp || $1 == *.c ]]; then
        make -s
        start=$(date +%s%3N)
        name=$1
        ./${name%.*} $output

    else
        echo Not an executable file type. Edit file ~/.vim/exec.sh
        exit 0
    fi
    
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

