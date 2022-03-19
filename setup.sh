#!/bin/bash

# Populate vim config directory with necessary directories.
mkdir -p .vim/files/backup
mkdir -p .vim/files/info
mkdir -p .vim/files/swap

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install plugins
vim +PlugInstall +qall
