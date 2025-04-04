# use self compiled executables contained in home/bin
append_path "$HOME/bin"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
append_path $PNPM_HOME
# pnpm end

# python pyenv
PYTHON_BIN_PATH="$(python3 -m site --user-base)/bin"
append_path $PYTHON_BIN_PATH

# dotnet
append_path "$HOME/.dotnet/tools"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
