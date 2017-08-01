# ~/.bash RC: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
    
# ┌────────────────────────┐
# │ General .bashrc setup  │
# └────────────────────────┘
    case $- in # If not running interactively, don't do anything  
        *i*) ;;
          *) return;;
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
    #force_color_prompt=yes
    
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
# │   Directory aliasing   │
# └────────────────────────┘
# personal directories
alias cdHill="cd ~/Google\ Drive/Work/Hill\ AFB/"
alias cdJournal="cd ~/Google\ Drive/Journaling/vim_journal"

# ┌────────────────────────┐
# │  Formatting Functions  │
# └────────────────────────┘
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

# ┌────────────────────────┐
# │  General Instructions  │
# └────────────────────────┘
# turn on vim commands in terminal
set -o vi

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
