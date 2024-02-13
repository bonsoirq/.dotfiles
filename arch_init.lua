#!/bin/lua

is_installed = function (packageName)
    return os.execute("pacman -Q " .. packageName)
end

pacman_install = function (packageName)
    os.execute("sudo pacman -S " .. packageName)
end

yay_install = function (packageName)
    os.execute("yay -S --noconfirm " .. packageName)
end

if not is_installed("git") then
  pacman_install("git")
end

if not is_installed("yay") then
    os.execute("git clone https://aur.archlinux.org/yay-bin.git")
    os.execute("cd yay-bin && makepkg -si")
    os.execute("rm -rf yay-bin")
end

yay_install_missing = function (packageName)
    if not is_installed(packageName) then
        yay_install(packageName)
    end
end

dependencies = {
    "bitwarden",
    "dex",
    "gnome-keyring",
    "google-chrome",
    "inter-font",
    "man",
    "nvm",
    "pyenv",
    "rofi",
    "ttf-jetbrains-mono-nerd",
    "vifm",
    "visual-studio-code-bin",
    "zsh",
}

for i, packageName in ipairs(dependencies) do
  local missing_dependencies = {}

  if not is_installed(packageName) then
    table.insert(missing_dependencies, packageName)
  end

  local dependencies_to_install = table.concat(missing_dependencies, " ")

  yay_install(dependencies_to_install)
end

zsh_bin_path = "/usr/bin/zsh"

if os.getenv("SHELL") ~= zsh_bin_path then
    os.execute("chsh -s " .. zsh_bin_path)
end

function file_exists(filepath)
  local file = io.open(filepath)
  return file ~= nil and io.close(file)
end

local user_home = os.getenv("HOME")

if not file_exists(user_home .. "/.ssh/id_ed25519.pub") then
  io.write("No ssh key found. Enter your email to generate a new key:\n")
  local email = io.read()

  os.execute("ssh-keygen -t ed25519 -C \"" .. email .. "\"")
end

