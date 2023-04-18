-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local constants = require("constants")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local rules = require("rules")
local xrandr = require("xrandr")
local workspaces = require("workspaces")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

local function toast(message)
	naughty.notify({
		preset = naughty.config.presets.normal,
		title = "Debug toast!",
		text = message,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end

awesome.connect_signal("startup", function()
	awful.spawn.once("autorandr -l default")
	-- Run compositor
	awful.spawn.once("picom -b")
	-- Run dropbox
	awful.spawn.once("dropbox")
	-- Set keyboard layout
	awful.spawn(
		"setxkbmap -model pc104 -layout pl -option grp:alt_shift_toggle"
	)
	-- Run polkit
	awful.spawn.once(
		"/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
	)
end)

-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

-- Table of layouts to cover with awful.layout.inc, order matters.
local available_layouts =
	{
		awful.layout.suit.tile,
		awful.layout.suit.tile.bottom,
		awful.layout.suit.floating,
	}
awful.layout.layouts = available_layouts

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

local function icon(name)
	local base_path = "/usr/share/icons/Papirus/64x64/apps/"
	local extension = ".svg"

	return base_path .. name .. extension
end

local context_menu = awful.menu({
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

local start_button = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = context_menu,
})

-- Menubar configuration
menubar.utils.terminal = constants.apps.terminal -- Set the terminal for applications that require it
-- Keyboard map indicator and switcher
local keyboard_layout_widget = awful.widget.keyboardlayout()

-- Create a textclock widget
local clock_widget = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local workspace_buttons = gears.table.join(
	awful.button({}, constants.mouse.left_click, function(workspace)
		workspace:view_only()
	end),
	awful.button(
		{ constants.keys.modkey },
		constants.mouse.left_click,
		function(workspace)
			if client.focus then
				client.focus:move_to_tag(workspace)
			end
		end
	),
	awful.button({}, constants.mouse.right_click, awful.tag.viewtoggle),
	awful.button(
		{ constants.keys.modkey },
		constants.mouse.right_click,
		function(workspace)
			if client.focus then
				client.focus:toggle_tag(workspace)
			end
		end
	),
	awful.button({}, constants.mouse.scroll_up, function(workspace)
		awful.tag.viewnext(workspace.screen)
	end),
	awful.button({}, constants.mouse.scroll_down, function(workspace)
		awful.tag.viewprev(workspace.screen)
	end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, constants.mouse.left_click, function(client)
		if client == client.focus then
			client.minimized = true
		else
			client:emit_signal("request::activate", "tasklist", {
				raise = true,
			})
		end
	end),
	awful.button({}, constants.mouse.right_click, function()
		awful.menu.client_list()
	end),
	awful.button({}, constants.mouse.scroll_up, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, constants.mouse.scroll_down, function()
		awful.client.focus.byidx(-1)
	end)
)

local function set_wallpaper()
	awful.spawn("nitrogen --restore")
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(screen)

-- Each screen has its own workspace table.

-- Create a promptbox for each screen
-- Create an imagebox widget which will contain an icon indicating which layout we're using.
-- We need one layoutbox per screen.
-- Create a taglist widget

-- Create a tasklist widget

-- Create the wibox

-- Add widgets to the wibox -- Left widgets -- Middle widget -- Right widgets
	set_wallpaper()

	local default_layout = awful.layout.layouts[1]
	local workspaces_for_screen = workspaces.by_screen[screen.index]

	awful.tag(workspaces_for_screen, screen, default_layout)

	screen.prompt = awful.widget.prompt()
	screen.layout_switcher = awful.widget.layoutbox(screen)
	screen.layout_switcher:buttons(
		gears.table.join(
			awful.button({}, constants.mouse.left_click, function()
				awful.layout.inc(1)
			end),
			awful.button({}, constants.mouse.right_click, function()
				awful.layout.inc(-1)
			end)
		)
	)
	screen.workspaces = awful.widget.taglist{
		screen = screen,
		filter = awful.widget.taglist.filter.all,
		buttons = workspace_buttons,
	}

	screen.tasklist = awful.widget.tasklist{
		screen = screen,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
	}

	screen.panel = awful.wibar({
		position = "top",
		screen = screen,
	})

	screen.panel:setup{
		layout = wibox.layout.align.horizontal,
		{
			layout = wibox.layout.fixed.horizontal,
			start_button,
			screen.workspaces,
			screen.prompt,
		},
		screen.tasklist,
		{
			layout = wibox.layout.fixed.horizontal,
			keyboard_layout_widget,
			wibox.widget.systray(),
			clock_widget,
			screen.layout_switcher,
		},
	}
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(
	gears.table.join(
		awful.button({}, constants.mouse.right_click, function()
			context_menu:toggle()
		end),
		awful.button({}, constants.mouse.scroll_up, awful.tag.viewnext),
		awful.button({}, constants.mouse.scroll_down, awful.tag.viewprev)
	)
)
-- }}}

-- {{{ Key bindings
local global_keys = gears.table.join(
	-- Menubar
	-- awful.key({ constants.keys.modkey, }, "p", function() menubar.show() end,
	--     { description = "show the menubar", group = "launcher" })
	awful.key({ constants.keys.modkey }, "s", hotkeys_popup.show_help, {
		description = "show help",
		group = "AwesomeWM",
	}),
	awful.key({ constants.keys.modkey }, "Left", awful.tag.viewprev, {
		description = "view previous",
		group = "Workspace",
	}),
	awful.key({ constants.keys.modkey }, "Right", awful.tag.viewnext, {
		description = "view next",
		group = "Workspace",
	}),
	awful.key({ constants.keys.modkey }, "Escape", awful.tag.history.restore, {
		description = "go back",
		group = "Workspace",
	}),

	awful.key(
		{ constants.keys.modkey },
		"j",
		function()
			awful.client.focus.byidx(1)
		end,
		{
			description = "Focus next window",
			group = "Window",
		}
	),
	awful.key(
		{ constants.keys.modkey },
		"k",
		function()
			awful.client.focus.byidx(-1)
		end,
		{
			description = "Focus previous window",
			group = "Window",
		}
	),
	awful.key(
		{ constants.keys.modkey },
		"w",
		function()
			context_menu:show()
		end,
		{
			description = "show main menu",
			group = "AwesomeWM",
		}
	),

	-- Audio control
	awful.key({}, constants.keys.audio_volume_up, function()
		awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
	end),
	awful.key({}, constants.keys.audio_volume_down, function()
		awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
	end),
	awful.key({}, constants.keys.audio_mute, function()
		awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
	end),
	awful.key({}, constants.keys.audio_play, function()
		awful.spawn("playerctl play-pause")
	end),
	awful.key({}, constants.keys.audio_stop, function()
		awful.spawn("playerctl pause")
	end),
	awful.key({}, constants.keys.audio_previous, function()
		awful.spawn("playerctl previous")
	end),
	awful.key({}, constants.keys.audio_next, function()
		awful.spawn("playerctl next")
	end),

	-- Brightness control
	awful.key({}, constants.keys.brightness_up, function()
		awful.spawn("brightnessctl set +10%")
	end),
	awful.key({}, constants.keys.brightness_down, function()
		awful.spawn("brightnessctl set 10%-")
	end),

	awful.key(
		{ constants.keys.modkey },
		"p",
		function()
			xrandr.xrandr()
		end,
		{
			description = "xrandr",
			group = "Apps",
		}
	),

	-- Apps
	awful.key(
		{ constants.keys.modkey },
		constants.keys.enter,
		function()
			awful.spawn(constants.apps.terminal)
		end,
		{
			description = "Terminal",
			group = "Apps",
		}
	),
	awful.key(
		{},
		"XF86Explorer",
		function()
			awful.spawn("google-chrome-stable")
		end,
		{
			description = "Google Chrome",
			group = "Apps",
		}
	),
	awful.key(
		{},
		"XF86HomePage",
		function()
			awful.spawn("nemo")
		end,
		{
			description = "Nemo",
			group = "Apps",
		}
	),
	awful.key(
		{},
		"XF86Mail",
		function()
			awful.spawn("thunderbird")
		end,
		{
			description = "Thunderbird",
			group = "Apps",
		}
	),
	awful.key(
		{},
		"XF86Tools",
		function()
			awful.spawn("spotify")
		end,
		{
			description = "Spotify",
			group = "Apps",
		}
	),

	-- Layout manipulation
	awful.key(
		{ constants.keys.modkey, constants.keys.shift },
		"j",
		function()
			awful.client.swap.byidx(1)
		end,
		{
			description = "swap with next client by index",
			group = "Window",
		}
	),
	awful.key(
		{ constants.keys.modkey, constants.keys.shift },
		"k",
		function()
			awful.client.swap.byidx(-1)
		end,
		{
			description = "swap with previous client by index",
			group = "Window",
		}
	),
	awful.key(
		{ constants.keys.modkey, constants.keys.ctrl },
		"j",
		function()
			awful.screen.focus_relative(1)
		end,
		{
			description = "focus the next screen",
			group = "screen",
		}
	),
	awful.key(
		{ constants.keys.modkey, constants.keys.ctrl },
		"k",
		function()
			awful.screen.focus_relative(-1)
		end,
		{
			description = "focus the previous screen",
			group = "screen",
		}
	),
	awful.key({ constants.keys.modkey }, "u", awful.client.urgent.jumpto, {
		description = "jump to urgent client",
		group = "Window",
	}),
	awful.key(
		{ constants.keys.modkey },
		"Tab",
		function()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end,
		{
			description = "go back",
			group = "Window",
		}
	),

	-- Standard program
	awful.key(
		{ constants.keys.modkey, constants.keys.ctrl },
		"r",
		awesome.restart,
		{
			description = "Reload awesome",
			group = "AwesomeWM",
		}
	),
	awful.key(
		{ constants.keys.modkey, constants.keys.shift },
		"q",
		function()
			awesome.quit()
		end,
		{
			description = "Quit awesome",
			group = "AwesomeWM",
		}
	),

	awful.key(
		{ constants.keys.modkey },
		"l",
		function()
			awful.tag.incmwfact(0.05)
		end,
		{
			description = "increase master width factor",
			group = "layout",
		}
	),
	awful.key(
		{ constants.keys.modkey },
		"h",
		function()
			awful.tag.incmwfact(-0.05)
		end,
		{
			description = "decrease master width factor",
			group = "layout",
		}
	),
	awful.key(
		{ constants.keys.modkey, constants.keys.shift },
		"h",
		function()
			awful.tag.incnmaster(1, nil, true)
		end,
		{
			description = "increase the number of master clients",
			group = "layout",
		}
	),
	awful.key(
		{ constants.keys.modkey, constants.keys.shift },
		"l",
		function()
			awful.tag.incnmaster(-1, nil, true)
		end,
		{
			description = "decrease the number of master clients",
			group = "layout",
		}
	),
	awful.key(
		{ constants.keys.modkey, constants.keys.ctrl },
		"h",
		function()
			awful.tag.incncol(1, nil, true)
		end,
		{
			description = "increase the number of columns",
			group = "layout",
		}
	),
	awful.key(
		{ constants.keys.modkey, constants.keys.ctrl },
		"l",
		function()
			awful.tag.incncol(-1, nil, true)
		end,
		{
			description = "decrease the number of columns",
			group = "layout",
		}
	),
	awful.key(
		{ constants.keys.modkey },
		"space",
		function()
			awful.spawn("rofi -show run")
		end,
		{
			description = "rofi",
			group = "Apps",
		}
	),
	awful.key(
		{ constants.keys.modkey, constants.keys.shift },
		"space",
		function()
			awful.spawn("rofimoji")
		end,
		{
			description = "rofimoji",
			group = "Apps",
		}
	),

	awful.key(
		{ constants.keys.modkey, constants.keys.ctrl },
		"n",
		function()
			local client = awful.client.restore()
			-- Focus restored client
			if client then
				client:emit_signal("request::activate", "key.unminimize", {
					raise = true,
				})
			end
		end,
		{
			description = "restore minimized",
			group = "Rclient",
		}
	),

	-- Prompt
	awful.key(
		{ constants.keys.modkey },
		"r",
		function()
			awful.screen.focused().mypromptbox:run()
		end,
		{
			description = "run prompt",
			group = "launcher",
		}
	),

	awful.key(
		{ constants.keys.modkey },
		"x",
		function()
			awful.prompt.run{
				prompt = "Run Lua code: ",
				textbox = awful.screen.focused().mypromptbox.widget,
				exe_callback = awful.util.eval,
				history_path = awful.util.get_cache_dir() .. "/history_eval",
			}
		end,
		{
			description = "lua execute prompt",
			group = "AwesomeWM",
		}
	)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	global_keys = gears.table.join(
		-- Toggle workspace on focused client.
		global_keys,
		-- View workspace only.
		awful.key(
			{ constants.keys.modkey },
			"#" .. i + 9,
			function()
				local screen = awful.screen.focused()
				local workspace = screen.tags[i]
				if workspace then
					workspace:view_only()
				end
			end,
			{
				description = "view workspace #" .. i,
				group = "Workspace",
			}
		),
		-- Toggle workspace display.
		awful.key(
			{ constants.keys.modkey, constants.keys.ctrl },
			"#" .. i + 9,
			function()
				local screen = awful.screen.focused()
				local workspace = screen.tags[i]
				if workspace then
					awful.tag.viewtoggle(workspace)
				end
			end,
			{
				description = "toggle workspace #" .. i,
				group = "Workspace",
			}
		),
		-- Move client to workspace.
		awful.key(
			{ constants.keys.modkey, constants.keys.shift },
			"#" .. i + 9,
			function()
				if client.focus then
					local workspace = client.focus.screen.tags[i]
					if workspace then
						client.focus:move_to_tag(workspace)
					end
				end
			end,
			{
				description = "move focused client to workspace #" .. i,
				group = "Workspace",
			}
		),
		awful.key(
			{
				constants.keys.modkey,
				constants.keys.ctrl,
				constants.keys.shift,
			},
			"#" .. i + 9,
			function()
				if client.focus then
					local workspace = client.focus.screen.tags[i]
					if workspace then
						client.focus:toggle_tag(workspace)
					end
				end
			end,
			{
				description = "toggle focused client on workspace #" .. i,
				group = "Workspace",
			}
		)
	)
end

root.keys(global_keys)

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = rules(beautiful)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(client)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	if not awesome.startup then
		awful.client.setslave(client)
	end

	if awesome.startup and not client.size_hints.user_position and not client.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(client)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(client)
	-- buttons for the titlebar
	local buttons = gears.table.join(
		awful.button({}, constants.mouse.left_click, function()
			client:emit_signal("request::activate", "titlebar", {
				raise = true,
			})
			awful.mouse.client.move(client)
		end),
		awful.button({}, constants.mouse.right_click, function()
			client:emit_signal("request::activate", "titlebar", {
				raise = true,
			})
			awful.mouse.client.resize(client)
		end)
	)

	awful.titlebar(client):setup{
		{
			-- Left
			awful.titlebar.widget.iconwidget(client),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		{
			-- Middle
			{
				-- Title
				align = "center",
				widget = awful.titlebar.widget.titlewidget(client),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{
			-- Right
			awful.titlebar.widget.floatingbutton(client),
			awful.titlebar.widget.maximizedbutton(client),
			awful.titlebar.widget.stickybutton(client),
			awful.titlebar.widget.ontopbutton(client),
			awful.titlebar.widget.closebutton(client),
			layout = wibox.layout.fixed.horizontal(),
		},
		layout = wibox.layout.align.horizontal,
	}
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(client)
	client:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

-- Strict focus, when a client under the mouse changes
client.connect_signal("mouse::move", function(client)
	client:emit_signal("request::activate", "mouse_enter", { raise = false })
end)