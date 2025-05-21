#!/usr/bin/env bash

# Check if stow is installed
if [ ! -e $(command -v stow) ]; then
	echo 'stow command not found, install it first'
	exit 1
fi

# Populate vim config directory with necessary directories.
mkdir -p ~/.dotfiles/.vim/files/{backup,info,swap}

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
	&
vim +PlugInstall +qall

# Download zsh-vi-mode if not downloaded already
[ ! -d "$HOME/.zsh-vi-mode" ] && git clone https://github.com/jeffreytse/zsh-vi-mode.git $HOME/.zsh-vi-mode
# Download lazyvim if not downloaded already
[ ! -d "$HOME/.config/nvim" ] && git clone https://github.com/LazyVim/starter $HOME/.dotfiles/neovim/.config/nvim

cd ~/.dotfiles/packages
echo "Setting stow directory to $PWD"

# Link rc files
stow -t ~ {alacritty,cava,fish,vifm,neovim,bash,git,zsh,nvm,vim,kitty}

if [ $(uname) = 'Linux' ]; then
	stow -t ~ {x11,awesomewm,i3wm,picom,polybar,rofi,hyprland,waybar}
fi

if [ $(uname) = 'Darwin' ]; then
	stow -t ~ skhd
fi
