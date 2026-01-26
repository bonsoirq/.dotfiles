# use self compiled executables contained in .local/bin
prepend_path "$HOME/.local/bin"

fish_add_path --prepend ~/.local/bin

mise activate fish | source
