#!/bin/bash

# Populate vim config directory with necessary directories.
mkdir -p .vim/files/{backup,info,swap}

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
  &
vim +PlugInstall +qall

# Download zsh-vi-mode if not downloaded already
[ ! -d "$HOME/.zsh-vi-mode" ] && git clone https://github.com/jeffreytse/zsh-vi-mode.git $HOME/.zsh-vi-mode

# Link rc files
rm -rf .gitconfig .zshrc .nvmrc .vimrc .config/alacritty \
  && ln -s ~/.dotfiles/{.gitconfig,.zshrc,.nvmrc,.vimrc} ~/
ln -s ~/.dotfiles/.config/alacritty ~/.config/alacritty

if [ $(uname) = 'Linux' ]; then
  rm -rf .xinitrc .Xresources .zprofile \
    .config/{awesome,cava,i3,picom,polybar,rofi} \
    && ln -s ~/.dotfiles/{.xinitrc,.Xresources,.zprofile} ~/
  ln -s ~/.dotfiles/.config/{awesome,cava,i3,picom,polybar,rofi} ~/.config
fi

if [ $(uname) = 'Darwin' ]; then
  rm -rf .config/skhd \
    && ln -s ~/.dotfiles/.config/skhd ~/.config/skhd
fi
