#!/bin/bash
# Name: Makefile Copier
# Author: Clint Ferrin
#
# Copies a Makefile from ~/.vim/ to current working directory 
#

main() {
curr_dir=$(pwd)
name=$1
if [[ ! $(find -iname makefile*) ]]
then
    if [[ $(find ~/.vim/ -maxdepth 1 -iname Makefile ) ]]
   then    
        echo Creating new makefile from ~/.vim/Makefile 
        cp ~/.vim/Makefile "$curr_dir"
        sed -i "s/program/$name/" Makefile 
        sed -i "s/program/${name%.*}/" Makefile 
    else echo $(red_bold Error:) No default Makefile found in ~/.vim/
    fi
else echo Makefile exists
fi

}

function red_bold() {
    echo -e "\e[1m$(echo -e "\e[31m$1\e[0m")\e[0m"
}

main "$@"
