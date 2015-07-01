#!/bin/bash

dotfiles=( vim vimrc zshrc tmux.conf vimshrc bashrc gitconfig agignore vimperatorrc vimperator)
for file in ${dotfiles[@]}
do
  if [ -a $HOME/.$file ]; then
    echo ".$file already exists."
  else
    ln -s $HOME/dotfiles/$file $HOME/.$file
    echo "success to create symlink .$file"
  fi
done

cd $HOME/dotfiles
git submodule update --init
