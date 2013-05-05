#!/bin/bash

dotfiles=( vim vimrc zshrc tmux.conf dir_colors vimshrc bashrc gitconfig agignore )
for file in ${dotfiles[@]}
do
  if [ -a $HOME/.$file ]; then
    echo ".$file already exists."
  else
    ln -s $HOME/dotfiles/$file $HOME/.$file
    echo "success to create symlink .$file"
  fi
done

# git clone neobundle.vim and zsh-completions
if [ `which git &> /dev/null` -o `which $HOME/local/bin/git &> /dev/null` ]; then
  if [ `vim --version | awk '/[0-9]\.[0-9]/' | cut -d" " -f5` = '7.3' ]; then
    if [ -a $HOME/.vim/bundle/neobundle.vim.git ]; then
      echo "[ERROR] neobundle already exists."
    else
      git clone http://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle
    fi
  fi
  if [ -d $HOME/.zsh-completions ]; then
    mkdir $HOME/.zsh-completions
    git clone http://github.com/zsh-users/zsh-completions.git $HOME/.zsh-completions
    rm -f ~/.zcompdump; compinit
  fi
else
  echo "git is not installed."
fi
