#/bin/bash
# Title: Set-up openCV 

  # Checks to see if tmux and vim are installed, and moves creates new .tmux,
  # .vim and .basrc files for a programming environment on Linux

main(){
# # check parameters
handleopts "$@"

# check if proper packages are installed 
check_install build-essential
check_install git 
check_install cmake
check_install libgtk2.0-dev 
check_install pkg-config 
check_install libavcodec-dev 
check_install libavformat-dev 
check_install libswscale-dev

cd /opt/
sudo git clone https://github.com/Itseez/opencv.git
sudo git clone https://github.com/Itseez/opencv_contrib.git
cd ./opencv/
mkdir release
cd release
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules /opt/opencv/

sudo make -j 4
sudo make install
pkg-config --modversion opencv

exit 0
}

function usage() {
    name=$(basename $0)
    echo $(bold "NAME: ") 
    echo ${name%.*} -  Install OpenCV |  indent
    echo

    # description
    echo $(bold "PROGRAM DESCRIPTION: ") 
        echo The program $0 will install the most current version of OpenCV on your system using the tutorial from the following site: http://embedonix.com/ articles/image-processing/ installing-opencv-3-1-0-on-ubuntu/ | indent
        echo

        echo $(bold "-v, --version") | indent
        echo Output Version information for program and exit. | indent 2
        echo

        echo $(bold "-h, --help") | indent
        echo Display this help documentation and exit program. | indent 2
        echo
        

    # author 
    echo $(bold "AUTHOR: ") 
    echo Written by Clint Ferrin | indent
}

function handleopts() {
    OPTS=`getopt -o no:vh -l no-backup -l open-vim -l version -l help -- "$@"`
    if [ $? != 0 ]
    then 
        echo ERROR parsing arguments >&2
        exit 1
    fi
    eval set -- "$OPTS"     # sets paramters into form that getopt evaluated
    while true; do
        case "$1" in
            -n | --no-backup ) 
                                no_backup=1 
                                shift;;  # throws away $1 and $2
                           
            -o | --open-vim   ) 
                                open_vim=1
                                open_new_file_name=$2
                                shift 2;;

            -v | --version    )
                                echo "Version 1.1"
                                usage;
                                exit 0;;

            -h | --help       )       
                                usage;
                                exit 0;;

            -- ) shift; break;;
        esac
    done
    if [ "$#" -ne 0 ]
    then
        echo Error: Extra command line arguments in \"$@\"
        usage 
    fi
}

function check_install() {
    typeset ans
    if (($(dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed")==0))
    then 
        echo "The program "$1" is not installed. Would you like to install it? (Y/n)"
        if [[ $(validate_Y_n) ]]
        then
            sudo apt -y install $1
        else
            echo $1 must be intalled for proper functionality 
        fi
    fi
}

function validate_Y_n() {
    typeset ans
    typeset valid=0
    while (( $valid==0 ))       
    do
        read ans
        case $ans in            
        yes|Yes|Y|y|"" ) echo TRUE 
                         valid=1 ;; 
                      
        [nN][oO]|n|N   ) 
                         valid=1 ;;
                      
         *             ) echo "Answer (Y/n)" ;;     
        esac                    
    done
}

function cp_backup() {
    typeset file=$1
    typeset new_location=$2
    # check if duplicate file
    if [[ $(find $new_location -maxdepth 1 \
        -iname $(basename $file) 2>/dev/null) ]]
    then
        # do not write over oldest version
        typeset past_version=$new_location$(basename $file)"_"$(date_tag)
        if [[ $(find $new_location -maxdepth 1 \
            -iname $(basename $past_version) 2>/dev/null) ]]
        then 
            # add hr, min, sec stamp if necessary
            typeset path=${new_location}/$(basename $file) 
            mv $path $past_version-$(date +"%H%M%S")
            echo $past_version-$(date +"%H%M%S")
        else 
            # make a backup of the old version 
            typeset path=${new_location}/$(basename $file) 
            mv $path $past_version
            echo $past_version
        fi
    fi
    # copy file to desired location
    cp -r $file $new_location
}

function date_tag() {
    typeset DAY=$(date -d "$D" '+%d')
    typeset MONTH=$(date -d "$D" '+%m')
    typeset YEAR=$(date -d "$D" '+%y') 
    echo $YEAR$MONTH$DAY
}

function bold() {
    echo -e "\e[1m$1\e[0m"
}

function indent() {
    # give parameter for number of tabs forward
    typeset tabs
    typeset spaces
    
    if (($# == 0))
    then tabs=1 
    else tabs=$1
    fi

    for (( i = 0; i < $tabs; i++ )); do
        spaces+="\t" 
    done
    cols=$(/usr/bin/tput cols)
    ((cols-=8*$tabs))
    fmt --width=$cols | sed "s/^/$spaces/"
}

main "$@"
