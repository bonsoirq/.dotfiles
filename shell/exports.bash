export BROWSER=chromium
export EDITOR=nvim

append_path () {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$PATH:$1" ;;
  esac
}
