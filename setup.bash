#!/usr/bin/env bash

# Populate vim config directory with necessary directories.
mkdir -p ~/.dotfiles/.vim/files/{backup,info,swap}

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
  &
vim +PlugInstall +qall

# Download zsh-vi-mode if not downloaded already
[ ! -d "$HOME/.zsh-vi-mode" ] && git clone https://github.com/jeffreytse/zsh-vi-mode.git $HOME/.zsh-vi-mode
# Download lazyvim if not downloaded already
[ ! -d "$HOME/.config/nvim" ] && git clone https://github.com/LazyVim/starter $HOME/.dotfiles/.config/nvim

# Link rc files
rm -rf ~/{.bashrc,.gitconfig,.zshrc,.nvmrc,.vimrc} ~/.config/{alacritty,cava,fish,vifm,nvim} \
  && ln -s ~/.dotfiles/{.bashrc,.gitconfig,.zshrc,.nvmrc,.vimrc} ~/
ln -s ~/.dotfiles/.config/{alacritty,cava,fish,vifm,nvim} ~/.config

if [ $(uname) = 'Linux' ]; then
  rm -rf ~/{.xinitrc,.Xresources,.zprofile} \
    ~/.config/{awesome,i3,picom,polybar,rofi,hypr} \
    && ln -s ~/.dotfiles/{.xinitrc,.Xresources,.zprofile} ~/
  ln -s ~/.dotfiles/.config/{awesome,i3,picom,polybar,rofi,hypr} ~/.config
fi

if [ $(uname) = 'Darwin' ]; then
  rm -rf ~/.config/skhd \
    && ln -s ~/.dotfiles/.config/skhd ~/.config/skhd
fi
