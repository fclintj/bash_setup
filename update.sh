#!/bin/bash
# update vim
vimdiff ./config/.vimrc ~/.vimrc
vimdiff ./config/.bashrc ~/.bashrc
vimdiff ./config/.inputrc ~/.inputrc
vimdiff ./config/.tmux.conf ~/.tmux.conf

# type the following commands into your vim editor
#   :DirDiff ~/dev/bash_setup/.vim/ ~/.vim/
#   :DirDiff ~/dev/bash_setup/.latex/ ~/.latex/
#   :DirDiff ~/dev/bash_setup/.tmux/ ~/.tmux/
#   :DirDiff ~/dev/bash_setup/.autokey/ ~/.config/autokey/data/
