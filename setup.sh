#!/bin/bash

# Populate vim config directory with necessary directories.
mkdir -p .vim/files/backup .vim/files/info .vim/files/swap

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    & vim +PlugInstall +qall

# Link rc files
rm .gitconfig .zshrc .nvmrc .vimrc &&
ln -s .dotfiles/.gitconfig .gitconfig
ln -s .dotfiles/.zshrc .zshrc
ln -s .dotfiles/.nvmrc .nvmrc
ln -s .dotfiles/.vimrc .vimrc

if [ $(uname) = 'Linux' ]; then
  rm .xinitrc .Xresources .zprofile \
    .config/alacritty/alacritty.yml .config/polybar/config.ini .config/polybar/launch.sh  \
    .config/i3/config .config/cava/config .config/rofi/config.rasi &&
  ln -s .dotfiles/.xinitrc .xinitrc
  ln -s .dotfiles/.Xresources .Xresources
  ln -s .dotfiles/.zprofile .zprofile
  ln .dotfiles/.config/alacritty/alacritty.yml .config/alacritty/alacritty.yml
  ln .dotfiles/.config/cava/config .config/cava/config
  ln .dotfiles/.config/i3/config .config/i3/config
  ln .dotfiles/.config/polybar/config.ini .config/polybar/config.ini
  ln .dotfiles/.config/polybar/launch.sh .config/polybar/launch.sh 
  ln .dotfiles/.config/rofi/config.rasi .config/rofi/config.rasi
fi
