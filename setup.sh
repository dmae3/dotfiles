#!/bin/bash

dotfiles=( vim vimrc zshrc tmux.conf dir_colors vimshrc bashrc )
for file in ${dotfiles[@]}
do
  if [ -a $HOME/.$file ]; then
    echo ".$file already exists."
  else
    ln -s $HOME/dotfiles/$file $HOME/.$file
    echo "success to create symlink .$file"
  fi
done

# git clone neobundle.vim
if type -P git > /dev/null 2>&1; then
  if [ -a $HOME/.bundle/neobundle.vim.git ]; then
    echo "neobundle already exists."
  else
    git clone https://github.com/Shougo/neobundle.vim $HOME/.bundle/neobundle.vim.git
  fi
else
  echo "git is not installed."
fi


