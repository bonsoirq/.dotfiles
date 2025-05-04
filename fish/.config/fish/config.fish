if status is-interactive
    # Commands to run in interactive sessions can go here
    source ~/.dotfiles/shell/aliases.bash
    source ~/.dotfiles/shell/exports.fish

    alias reload='source ~/.config/fish/config.fish'
end
