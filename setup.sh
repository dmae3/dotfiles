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

# source bashrc before finding git
if $(cat ~/.bashrc | grep "PATH=$HOME/local/bin:$PATH"); then
    source ~/.bashrc
else
    echo 'PATH=$HOME/local/bin:$PATH' > ~/.bashrc
    source ~/.bashrc

# git clone neobundle.vim
if type -P git > /dev/null 2>&1; then
  if [ `vim --version | awk '/[0-9]\.[0-9]/' | cut -d" " -f5` = '7.3' ]; then
    if [ -a $HOME/.vim/bundle/neobundle.vim.git ]; then
    echo "[ERROR] neobundle already exists."
    else
      git clone http://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle
    fi
  else
    if [ -a $HOME/.vim/bundle/vundle.git ]; then
      echo "[ERROR] vundle already exists."
    else
      git clone http://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
    fi
  fi
else
  echo "git is not installed."
fi


