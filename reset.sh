#!/bin/bash

files=( vimrc zshrc tmux.conf dir_colors vimshrc bashrc )
directories=( vim vimfiler vimshell unite )

for file in ${files[@]}
do
    if [ -a $HOME/.${file} ]; then
        if rm -f $HOME/.${file}; then
            echo "removed ${file}."
        else
            echo "failed to remove ${file}."
        fi
    fi
done

for directory in ${directories[@]}
do
    if [ -a $HOME/.${directory} ]; then
        if rm -rf $HOME/.${directory}; then
            echo "removed ${directory}."
        else
            echo "failed to remove ${directory}."
        fi
    fi
done
