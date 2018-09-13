# ~/.bash RC: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
    
# ┌────────────────────────┐
# │ General .bashrc setup  │
# └────────────────────────┘
    case $- in # If not running interactively, don't do anything  
        *i*) ;;
          *) ;;
    esac
    
    # don't put duplicate lines or lines starting with space in the history.
    # See bash(1) for more options
    HISTCONTROL=ignoreboth
    
    # append to the history file, don't overwrite it
    shopt -s histappend
    
    # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
    HISTSIZE=1000
    HISTFILESIZE=2000
    
    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize
    
    # If set, the pattern "**" used in a pathname expansion context will
    # match all files and zero or more directories and subdirectories.
    #shopt -s globstar
    
    # make less more friendly for non-text input files, see lesspipe(1)
    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
    
    # set variable identifying the chroot you work in (used in the prompt below)
    if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi
    
    # set a fancy prompt (non-color, unless we know we "want" color)
    case "$TERM" in
        xterm|xterm-color|*-256color) color_prompt=yes;;
    esac
    
    # uncomment for a colored prompt, if the terminal has the capability; turned
    # off by default to not distract the user: the focus in a terminal window
    # should be on the output of commands, not on the prompt
    force_color_prompt=yes
    
    if [ -n "$force_color_prompt" ]; then
        if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    	# We have color support; assume it's compliant with Ecma-48
    	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    	# a case would tend to support setf rather than setaf.)
    	color_prompt=yes
        else
    	color_prompt=
        fi
    fi
    # lowercase \w makes complete path appear for current location
    if [ "$color_prompt" = yes ]; then
        if [[ ${EUID} == 0 ]] ; then
            PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
        else
            PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\W \$\[\033[00m\] '
        fi
    else
        PS1='${debian_chroot:+($debian_chroot)}\u@\h \w \$ '
    fi
    unset color_prompt force_color_prompt
    
    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h \W\a\]$PS1"
        ;;
    *)
        ;;
    esac
    
    # enable color support of ls and also add handy aliases
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        #alias dir='dir --color=auto'
        #alias vdir='vdir --color=auto'
    
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi
    
    # colored GCC warnings and errors
    #export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
    
    # some more ls aliases
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
    
    # Add an "alert" alias for long running commands.  Use like so:
    #   sleep 10; alert
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
    
    # Alias definitions.
    # You may want to put all your additions into a separate file like
    # ~/.bash_aliases, instead of adding them here directly.
    # See /usr/share/doc/bash-doc/examples in the bash-doc package.
    
    if [ -f ~/.bash_aliases ]; then
        . ~/.bash_aliases
    fi
    
    # enable programmable completion features (you don't need to enable
    # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
    # sources /etc/bash.bashrc).
    if ! shopt -oq posix; then
      if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
      elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
      fi
    fi
    
    if [ -x /usr/bin/mint-fortune ]; then
         /usr/bin/mint-fortune
    fi

# ┌────────────────────────┐
# │  Formatting Functions  │
# └────────────────────────┘
    function ros_build() {
        path=$PWD

        while [[ $path != $HOME && $path != \/ && $path != \/home ]]; do
            if [[ -d "$path/src" && -d "$path/devel" && "$path/build" ]]; then
                catkin_make -C $path
                source $path/devel/setup.bash

                output=""
                # run launch file if available 
                for i in $(<$path/params); do 
                    output+=" $i"
                done 2>/dev/null
                echo $output

                if [[ $output != "" ]]; then
                    clear
                    # print running title
                    echo  "-------- Running --------"
                    $output
                fi
                return 0
            fi
            path=${path%/*}
        done

        echo To build ROS, navigate to a folder or subfolder with:
        echo 
        echo -e '   build, devel, src'
        echo
        return 1
    }

    function rosbag2csv() {
           bagName="$1"
           topics="${@:2}"

           for topic in $topics ; do
               writeName=${topic/\//}
               rostopic echo -b $bagName -p $topic > ${writeName//\//\-}.csv
           done
       } 

    function print_title() {
        typeset spaces
        typeset i=0 
        typeset j=0
        
        if (("$#" < 1 )); 
        then 
            echo $(red_bold Error:) Argument required
            return 1
        fi

        echo -e ┌───────────────────────────────┐
        for i in "$@"
        do
            echo -en │ $i
            ((spaces=30-${#i}))

            for j in `seq 1 $spaces` 
            do 
                echo -en " "
            done
            echo -e │    
        done
        echo -e └───────────────────────────────┘
    }
    # Ex: echo "This is a $(underline test)"
    function bold() {
        echo -e "\e[1m$1\e[0m"
    }

    function red() {
        echo -e "\e[31m$1\e[0m"
    }

    function italics() {
        echo -e "\e[3m$1\e[0m"
    }

    function underline() {
        echo -e "\e[4m$1\e[0m"
    }

    function red_bold() {
        echo -e "\e[1m$(echo -e "\e[31m$1\e[0m")\e[0m"
    }

# ┌────────────────────────┐
# │    Program Functions   │
# └────────────────────────┘

function check_install() {
    typeset ans
    if (($(dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed")==0))
    then 
        echo "The program "$1" is not installed. Would you like to install it? (Y/n)"
        if [[ $(validate_Y_n) ]]
        then
            sudo apt install $1
        else
            echo $1 must be intalled for proper functionality 
        fi
    fi
}

function img2pdf() {
    mkdir tmp_convert_pdf
    for img in "$@" ; do
        convert $img ${img%.*}.pdf
        mv ${img%.jpg}.pdf tmp_convert_pdf
    done

    pdftk ./tmp_convert_pdf/*.pdf cat output combined.pdf
    rm -r tmp_convert_pdf
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

function mkcd() {
    mkdir "$1"
    cd "$1"
}

function cdl() {
    cd $1 
    ls
}

function vimjournal() {
    cd '/mnt/CE6C52926C527565/Users/clint/Google\ Drive/Journaling/vim_journal'
    vim ./journal.tex
}

function tmux_kill() {
    list="$(tmux ls | awk '{print $1}' | sed 's/://g')"
    re='^[0-9]+$' 

    for i in $list; do
        if [[ $i =~ $re ]] ; then
            tmux kill-session -t $i 
        fi 
    done
}

function readpdf() {
    convert -density 300 $1 -depth 8 -strip -background white -alpha off file.tiff
    tesseract file.tiff $1
    rm file.tiff
}

function findrm() {
    find -iname $1 -exec rm {} \; 
}

function num_args() {
    echo "$@" |awk '{for(i=0;i<=NF;i++); print i-1 }'
}

function cd_func () {
    local x2 the_new_dir adir index
    local -i cnt

    if [[ $1 ==  "--" ]]; then
        dirs -v
        return 0
    fi

    the_new_dir=$1
    [[ -z $1 ]] && the_new_dir=$HOME

    if [[ ${the_new_dir:0:1} == '-' ]]; then
        #
        # Extract dir N from dirs
        index=${the_new_dir:1}
        [[ -z $index ]] && index=1
        adir=$(dirs +$index)
        [[ -z $adir ]] && return 1
        the_new_dir=$adir
    fi

    #
    # '~' has to be substituted by ${HOME}
    [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"

    #
    # Now change to the new dir and add to the top of the stack
    pushd "${the_new_dir}" > /dev/null
    [[ $? -ne 0 ]] && return 1
    the_new_dir=$(pwd)

    #
    # Trim down everything beyond 11th entry
    popd -n +11 2>/dev/null 1>/dev/null

    #
    # Remove any other occurence of this dir, skipping the top of the stack
    for ((cnt=1; cnt <= 10; cnt++)); do
        x2=$(dirs +${cnt} 2>/dev/null)
        [[ $? -ne 0 ]] && return 0
        [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
        if [[ "${x2}" == "${the_new_dir}" ]]; then
            popd -n +$cnt 2>/dev/null 1>/dev/null
            cnt=cnt-1
        fi
    done

    return 0
}


# ┌────────────────────────┐
# │     color settings     │
# └────────────────────────┘
# alias ls='ls --color'
# LS_COLORS='di=34;42:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=32:*.rpm=90'
# export LS_COLORS
# http://linux-sxs.org/housekeeping/lscolors.html 

# ┌────────────────────────┐
# │     PATH variables     │
# └────────────────────────┘

export QT_QPA_PLATFORMTHEME=gtk2
source /opt/ros/kinetic/setup.bash
export PYTHONPATH="${PYTHONPATH}:/opt/ros/kinetic/share/"

# ┌────────────────────────┐
# │  General Instructions  │
# └────────────────────────┘
# turn on vim commands in terminal
    set -o vi
    
    case $- in *i*)
            [ -z "$TMUX" ] && exec tmux # attach -t master 
    esac

# # make mouse disappear after 0.2 seconds
# unclutter -idle 0.2 -root &

# pipe output from terminal into clipboard
    alias "c=xclip"
    alias "v=xclip -o"
    alias "cs=xclip -selection clipboard"
    alias "vs=xclip -o -selection clipboard"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
    alias lslarge='find -type f -exec ls -s {} \; | sort -n -r | head -5 | pv'

# general directory/file locations
    alias cdsnippets='cd ~/.vim/bundle/vim-snippets/snippets'
    alias d='nemo . &'
    alias e='nemo . &'
    alias cd=cd_func

    alias bashrc='vim ~/.bashrc'
    alias vimrc='vim ~/.vimrc'
    alias vim-run='vim ~/.vim/run_prog.sh'
    alias cdrtp='cd ~/Google\ Drive/School/Classes/Real\ Time\ Processors'
    alias open="xdg-open"
    alias default="xdg-open"
    alias piksi="/home/clint/Downloads/swift_console_v1.5.12_linux/console -b 1000000 -p /dev/ttyUSB0"
# bindings
    bind '"\e[24~":"ros_build\n'
    alias roskill='killall -9 rosmaster'

# update ROS variable env
    ros_build
    clear
