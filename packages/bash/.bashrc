#
# ~/.bashrc
#
source ~/.dotfiles/shell/exports.bash
source ~/.dotfiles/shell/exports-$(uname).bash

# If not running interactively, don't do anything below
[[ $- != *i* ]] && return

source ~/.dotfiles/shell/aliases.bash

alias reload='source ~/.bashrc'
PS1='[\u@\h \W]\$ '

eval "$(mise activate bash)"