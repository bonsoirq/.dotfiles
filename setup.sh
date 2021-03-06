#!/bin/bash

# Populate vim config directory with necessary directories.
mkdir -p .vim/files/{backup,info,swap}

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
& vim +PlugInstall +qall

# Download zsh-vi-mode if not downloaded already
[ ! -d "$HOME/.zsh-vi-mode" ] && git clone https://github.com/jeffreytse/zsh-vi-mode.git $HOME/.zsh-vi-mode

# Link rc files
rm -rf .gitconfig .zshrc .nvmrc .vimrc .config/alacritty  &&
mkdir -p .config/alacritty &&
ln -s .dotfiles/.gitconfig .gitconfig
ln -s .dotfiles/.zshrc .zshrc
ln -s .dotfiles/.nvmrc .nvmrc
ln -s .dotfiles/.vimrc .vimrc
ln .dotfiles/.config/alacritty/alacritty.yml .config/alacritty/alacritty.yml

if [ $(uname) = 'Linux' ]; then
    rm -rf .xinitrc .Xresources .zprofile \
    .config/{awesome,cava,i3,picom,polybar,rofi} &&
    mkdir -p .config/{awesome,cava,i3,picom,polybar,rofi} &&
    ln -s .dotfiles/.xinitrc .xinitrc
    ln -s .dotfiles/.Xresources .Xresources
    ln -s .dotfiles/.zprofile .zprofile
    ln .dotfiles/.config/awesome/rc.lua .config/awesome/rc.lua
    ln .dotfiles/.config/awesome/theme.lua .config/awesome/theme.lua
    ln .dotfiles/.config/cava/config .config/cava/config
    ln .dotfiles/.config/i3/config .config/i3/config
    ln .dotfiles/.config/picom/picom.conf .config/picom/picom.conf
    ln .dotfiles/.config/polybar/config.ini .config/polybar/config.ini
    ln .dotfiles/.config/polybar/launch.sh .config/polybar/launch.sh
    ln .dotfiles/.config/rofi/config.rasi .config/rofi/config.rasi
fi

if [ $(uname) = 'Darwin' ]; then
    rm -rf .config/skhd &&
    mkdir -p .config/skhd &&
    ln .dotfiles/.config/skhd/skhdrc .config/skhd/skhdrc
fi
