#!/bin/bash

# Populate vim config directory with necessary directories.
mkdir -p .vim/files/backup .vim/files/info .vim/files/swap

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    & vim +PlugInstall +qall

# Link rc files
ln -s .dotfiles/.gitconfig .gitconfig
ln -s .dotfiles/.zshrc .zshrc
ln -s .dotfiles/.nvmrc .nvmrc
ln -s .dotfiles/.vimrc .vimrc

if [ $(uname) = 'Linux' ]; then
  ln -s .dotfiles/.xinitrc .xinitrc
  ln .dotfiles/.config/bspwm/bspwmrc .config/bspwm/bspwmrc
  ln .dotfiles/.config/sxhkd/sxhkdrc .config/sxhkd/sxhkdrc
  ln .dotfiles/.config/alacritty/alacritty.yml .config/alacritty/alacritty.yml
  ln .dotfiles/.config/polybar/config.ini .config/polybar/config.ini
  ln .dotfiles/.config/polybar/launch.sh .config/polybar/launch.sh
fi
