#!/usr/bin/python

import os
from os import path
from subprocess import run
from pathlib import Path

def normalize_path(file_path):
  return path.normpath(path.expanduser(file_path))

pwd = os.getcwd()
expected_pwd = normalize_path(path.join('~', '.dotfiles'))

def ensure_correct_pwd():
  assert pwd == expected_pwd, 'the script should be run from inside ~/.dotfiles'

def install_vim_plug():
  run(['curl', '-fLo', '~/.vim/autoload/plug.vim', '--create-dirs', 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'])
  run(['vim', '+PlugInstall', '+qall'])

def directory_exists(directory_path):
  return path.isdir(directory_path)

def install_zsh_vi_mode():
  if directory_exists('~/.dotfiles/.zsh-vi-mode'):
    return
  run(['git', 'clone', 'https://github.com/jeffreytse/zsh-vi-mode.git', '~/.dotfiles/.zsh-vi-mode'])

def install_neovim():
  if directory_exists('~/.dotfiles/.config/nvim'):
    return
  run(['git', 'clone', 'https://github.com/LazyVim/starter', '~/.dotfiles/.config/nvim'])

COMMON_FILES = [
  '.gitconfig',
  '.zshrc',
  '.nvmrc',
  '.vimrc',
  '.config/alacritty',
  '.config/vifm',
  '.config/nvim',
  '.config/kitty',
]

def remove_file_if_exists(file_path):
  path = Path(file_path)  
  if path.is_file() or path.is_symlink():
    os.remove(file_path) 
    return
  if path.is_dir():
    os.rmdir(file_path)

def create_symlink(from_path, to_path):
  print("Creating symlink from", from_path, 'to', to_path)
  os.symlink(to_path, from_path)

for file_path in COMMON_FILES:
  symlink_path = normalize_path(path.join('~', file_path))
  config_file_path = normalize_path(path.join('~/.dotfiles', file_path))

  remove_file_if_exists(symlink_path)
  create_symlink(symlink_path, config_file_path)

ensure_correct_pwd()
install_vim_plug()
install_zsh_vi_mode()
install_neovim()
