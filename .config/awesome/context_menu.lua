local awful = require("awful")
local beautiful = require("beautiful")
local constants = require("constants")
local hotkeys_popup = require("awful.hotkeys_popup")

local function icon(name)
	local base_path = "/usr/share/icons/Papirus/64x64/apps/"
	local extension = ".svg"

	return base_path .. name .. extension
end

-- Create a launcher widget and a main menu
local awesomewm_submenu = { { "Hotkeys", function()
	hotkeys_popup.show_help(nil, awful.screen.focused())
end }, {
	"Manual",
	constants.apps.terminal .. " -e man awesome",
}, {
	"Configuration (VS Code)",
	"code" .. " " .. awesome.conffile,
}, { "Restart Awesome WM", awesome.restart }, { "Quit Awesome WM", function()
	awesome.quit()
end } }

local _context_menu = awful.menu({
	items = {
		{ "Awesome WM", awesomewm_submenu, beautiful.awesome_icon },
		{
			"Alacritty",
			constants.apps.terminal,
			icon("com.alacritty.Alacritty"),
		},
		{ "Baobab", "baobab", icon("baobab") },
		{ "Bitwarden", "bitwarden-desktop", icon("bitwarden") },
		{ "Blueberry", "blueberry", icon("bluetooth-48") },
		{ "Chrome", "google-chrome-stable", icon("google-chrome") },
		{ "Discord", "discord", icon("discord") },
		{ "Evince", "evince", icon("evince") },
		{ "Flameshot", "flameshot", icon("flameshot") },
		{ "Gedit", "gedit", icon("gedit") },
		{ "GPArted", "gparted", icon("gparted") },
		{ "Minecraft", "minecraft-launcher", icon("minecraft-launcher") },
		{ "Nemo", "nemo", icon("nemo") },
		{ "Nitrogen", "nitrogen", icon("nitrogen") },
		{ "Obsidian", "obsidian", icon("obsidian") },
		{ "Slack", "slack", icon("slack") },
		{ "Spotify", "spotify", icon("spotify") },
		{ "Steam", "steam", icon("steam") },
		{ "Thunderbird", "thunderbird", icon("thunderbird") },
		{ "Tor Browser", "tor-browser", icon("tor-browser") },
		{ "Transmission", "transmission-gtk", icon("transmission") },
		{ "Virtualbox", "virtualbox", icon("virtualbox") },
		{ "VLC", "vlc", icon("vlc") },
		{ "VS Code", "code", icon("visual-studio-code") },
		{ "Zoom", "zoom", icon("us.zoom.Zoom") },
	},
})

return _context_menu