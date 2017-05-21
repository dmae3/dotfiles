#!/bin/bash

dotfiles=( vim vimrc zshenv zshrc tmux.conf tmux vimshrc bashrc gitconfig agignore vimperatorrc vimperator)
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

# install zplug
curl -sL https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

# setting for neovim
[[ -d $HOME/.config/nvim ]] && mkdir -p $HOME/.config/nvim
ln -s $HOME/dotfiles/vimrc $HOME/.config/nvim/init.vim
