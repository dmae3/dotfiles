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
ln -s $HOME/dotfiles/vim/dein/coc/coc-settings.json $HOME/.config/nvim/coc-settings.json
mkdir -p $HOME/.config/coc/extensions
ln -s $HOME/dotfiles/vim/dein/coc/package.json $HOME/.config/coc/extensions/package.json

# install anyenv
git clone https://github.com/riywo/anyenv ~/.anyenv

# refresh SHELL
exec $SHELL -l

# install anyenv plugins
mkdir -p $(anyenv root)/plugins
git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update
git clone https://github.com/znz/anyenv-git.git $(anyenv root)/plugins/anyenv-git

# === fish setup ===

# Install fish
if ! command -v fish &>/dev/null; then
  echo "Installing fish..."
  brew install fish
fi

# Add fish to /etc/shells
FISH_PATH=/opt/homebrew/bin/fish
if ! grep -qF "$FISH_PATH" /etc/shells; then
  echo "Adding $FISH_PATH to /etc/shells..."
  echo "$FISH_PATH" | sudo tee -a /etc/shells
fi

# Create symlink ~/.config/fish -> ~/dotfiles/fish
mkdir -p "$HOME/.config"
if [ -e "$HOME/.config/fish" ]; then
  echo ".config/fish already exists."
else
  ln -s "$HOME/dotfiles/fish" "$HOME/.config/fish"
  echo "success to create symlink .config/fish"
fi

# Install Fisher, then install plugins from fish_plugins
fish -c "
  curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
  fisher install jorgebucaran/fisher
  fisher update
"

echo "Fish setup complete. Run 'tide configure' to customize the prompt."
