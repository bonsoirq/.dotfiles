# Dotfiles

## Setup

Run `setup.bash`

## Dev dependencies

[StyLua](https://github.com/JohnnyMorganz/StyLua)
[shfmt](https://github.com/mvdan/sh)


## Package manager dumps

### Homebrew

Running dump:

`brew bundle dump --describe --force`

Restoring dump:

`brew bundle`

### Pacman or Yay

Running dump:

`yay -Q --explicit --unrequired > yayfile`
