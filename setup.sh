#!/usr/bin/env bash

# Check if stow is installed
if [ ! -e $(command -v stow) ]; then
	echo 'stow command not found, install it first'
	exit 1
fi

# Populate vim config directory with necessary directories.
mkdir -p ~/.dotfiles/.vim/files/{backup,info,swap}

cd ~/.dotfiles/packages
echo "Setting stow directory to $PWD"

# Link rc files
stow -t ~ {alacritty,cava,fish,vifm,neovim,bash,git,zsh,nvm,vim,kitty}

if [ $(uname) = 'Linux' ]; then
	stow -t ~ {x11,awesomewm,i3wm,mise,noctalia,picom,polybar,pyenv,quickshell,rofi,hyprland,hyprlock,waybar,bin-Linux}
fi

if [ $(uname) = 'Darwin' ]; then
	stow -t ~ skhd
fi
