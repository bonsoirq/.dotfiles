set --export BROWSER chromium
set --export EDITOR nvim
pyenv init - fish | source

set PYTHON_VENV ~/.local/bin/.venv/bin/activate.fish
if  [ -e $PYTHON_VENV ]
    source $PYTHON_VENV
else
    echo "Python venv activator expected under $PYTHON_VENV but not found."
end
