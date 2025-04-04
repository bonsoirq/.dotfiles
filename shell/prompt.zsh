# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git*' formats "%b"

# Load prompt colors
autoload colors && colors

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
PROMPT='%n@%m:%~ %? $ %{$fg[green]%}${vcs_info_msg_0_} %{$reset_color%}'
