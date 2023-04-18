local awful = require("awful")
local client_buttons = require("client_buttons")
local client_keys = require("client_keys")

return function(beautiful)
	return { -- All clients will match this rule.
	{
		rule = {},
		properties = {
			focus = awful.client.focus.filter,
			raise = true,
			keys = client_keys,
			buttons = client_buttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	}, {
		rule = { class = "google-chrome" },
		properties = { tag = "web" },
	}, {
		rule = { class = "code" },
		properties = { tag = "code" },
	}, {
		rule = { class = "Steam" },
		properties = { tag = "steam" },
	}, {
		rule = { class = "Spotify" },
		properties = { tag = "music" },
	}, {
		rule = { class = "thunderbird" },
		properties = { tag = "mail" },
	}, {
		-- Floating clients.
		rule_any = {
			instance = { "DTA", "copyq", "pinentry", "steam_app_" }, -- Includes session name in class. -- Steam game
			class = { "Arandr", "Blueman-manager", "Tor Browser" }, -- Needs a fixed window size to avoid fingerprinting by screen size.
			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = { "Event Tester", "Terraria" }, -- xev.
			role = { "AlarmWindow", "ConfigManager", "pop-up" }, -- Thunderbird's calendar. -- Thunderbird's about:config. -- e.g. Google Chrome's (detached) Developer Tools.
		},
		properties = {
			floating = true,
			placement = awful.placement.centered,
		},
	}, {
		-- Add titlebars to normal clients and dialogs
		rule_any = {
			type = { "normal", "dialog" },
		},
		properties = { titlebars_enabled = false },
	} }
end