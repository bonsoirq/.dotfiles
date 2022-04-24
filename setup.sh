#!/bin/bash

# Populate vim config directory with necessary directories.
mkdir -p .vim/files/backup
mkdir -p .vim/files/info
mkdir -p .vim/files/swap

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install plugins
vim +PlugInstall +qall

ln -s .dotfiles/.gitconfig .gitconfig
ln -s .dotfiles/.zshrc .zshrc
ln -s .dotfiles/.nvmrc .nvmrc
ln -s .dotfiles/.vimrc .vimrc
ln -s .dotfiles/.xinitrc .xinitrc
ln -s .dotfiles/.config/bspwm .config/bspwm
ln -s .dotfiles/.config/sxhkd .config/sxhkd
ln -s .dotfiles/.config/polybar .config/polybar
