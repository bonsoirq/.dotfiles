#!/bin/lua

is_installed = function (packageName)
    return os.execute("pacman -Qi " .. packageName)
end

pacman_install = function (packageName)
    os.execute("sudo pacman -S " .. packageName)
end

yay_install = function (packageName)
    os.execute("yay -S --noconfirm " .. packageName)
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

installed_packages = {
    "bitwarden",
    "google-chrome",
    "rofi",
    "ttf-jetbrains-mono-nerd",
    "vifm",
    "visual-studio-code-bin",
    "zsh",
}

for i, packageName in ipairs(installed_packages) do
    yay_install_missing(packageName)
end

zsh_bin_path = "/usr/bin/zsh"

if os.getenv("SHELL") ~= zsh_bin_path then
    os.execute("chsh -s " .. zsh_bin_path)
end

