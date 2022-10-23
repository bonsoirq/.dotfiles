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
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
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
	-- Setup monitors once after startup
	awful.spawn.once("mons -e left")
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

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

-- This is used later as the default terminal and editor to run.
local terminal = constants.apps.terminal
local editor = constants.apps.editor
local editor_cmd = terminal .. " -e " .. editor

local keys = constants.keys

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts =
	{
		awful.layout.suit.tile,
		awful.layout.suit.tile.bottom,
		awful.layout.suit.floating,
	}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
local myawesomemenu = { { "hotkeys", function()
	hotkeys_popup.show_help(nil, awful.screen.focused())
end }, {
	"manual",
	terminal .. " -e man awesome",
}, {
	"edit config",
	editor_cmd .. " " .. awesome.conffile,
}, { "restart", awesome.restart }, { "quit", function()
	awesome.quit()
end } }

local function icon(name)
	local base_path = "/usr/share/icons/Papirus/32x32/apps/"
	local extension = ".svg"

	return base_path .. name .. extension
end

local mymainmenu = awful.menu({
	items = {
		{ "awesome", myawesomemenu, icon("distributor-logo-archlinux") },
		{ "Alacritty", terminal, icon("com.alacritty.Alacritty") },
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
		{ "Transmission", "transmission-gtk", icon("transmission") },
		{ "Virtualbox", "virtualbox", icon("virtualbox") },
		{ "VLC", "vlc", icon("vlc") },
		{ "VS Code", "code", icon("visual-studio-code") },
		{ "Zoom", "zoom", icon("us.zoom.Zoom") },
	},
})

local mylauncher = awful.widget.launcher({
	image = icon("distributor-logo-archlinux"),
	menu = mymainmenu,
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ keys.modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ keys.modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({
			theme = { width = 250 },
		})
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

local function set_wallpaper()
	awful.spawn("nitrogen --restore")
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(screen)

-- Each screen has its own tag table.

-- Create a promptbox for each screen
-- Create an imagebox widget which will contain an icon indicating which layout we're using.
-- We need one layoutbox per screen.
-- Create a taglist widget

-- Create a tasklist widget

-- Create the wibox

-- Add widgets to the wibox -- Left widgets -- Middle widget -- Right widgets
	set_wallpaper()

	local default_layout = awful.layout.layouts[1]
	local tags_by_screen =
		{
			{ "6", "7", "8", "9", "steam" },
			{ "web", "code", "cli", "mail", "chat" },
		}

	awful.tag(tags_by_screen[screen.index], screen, default_layout)

	screen.mypromptbox = awful.widget.prompt()
	screen.mylayoutbox = awful.widget.layoutbox(screen)
	screen.mylayoutbox:buttons(
		gears.table.join(
			awful.button({}, 1, function()
				awful.layout.inc(1)
			end),
			awful.button({}, 3, function()
				awful.layout.inc(-1)
			end),
			awful.button({}, 4, function()
				awful.layout.inc(1)
			end),
			awful.button({}, 5, function()
				awful.layout.inc(-1)
			end)
		)
	)
	screen.mytaglist = awful.widget.taglist{
		screen = screen,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
	}

	screen.mytasklist = awful.widget.tasklist{
		screen = screen,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
	}

	screen.mywibox = awful.wibar({
		position = "top",
		screen = screen,
	})

	screen.mywibox:setup{
		layout = wibox.layout.align.horizontal,
		{
			layout = wibox.layout.fixed.horizontal,
			mylauncher,
			screen.mytaglist,
			screen.mypromptbox,
		},
		screen.mytasklist,
		{
			layout = wibox.layout.fixed.horizontal,
			mykeyboardlayout,
			wibox.widget.systray(),
			mytextclock,
			screen.mylayoutbox,
		},
	}
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(
	gears.table.join(
		awful.button({}, 3, function()
			mymainmenu:toggle()
		end),
		awful.button({}, 4, awful.tag.viewnext),
		awful.button({}, 5, awful.tag.viewprev)
	)
)
-- }}}

-- {{{ Key bindings
local global_keys = gears.table.join(
	-- Menubar
	-- awful.key({ keys.modkey, }, "p", function() menubar.show() end,
	--     { description = "show the menubar", group = "launcher" })
	awful.key({ keys.modkey }, "s", hotkeys_popup.show_help, {
		description = "show help",
		group = "AwesomeWM",
	}),
	awful.key({ keys.modkey }, "Left", awful.tag.viewprev, {
		description = "view previous",
		group = "tag",
	}),
	awful.key({ keys.modkey }, "Right", awful.tag.viewnext, {
		description = "view next",
		group = "tag",
	}),
	awful.key({ keys.modkey }, "Escape", awful.tag.history.restore, {
		description = "go back",
		group = "tag",
	}),

	awful.key(
		{ keys.modkey },
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
		{ keys.modkey },
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
		{ keys.modkey },
		"w",
		function()
			mymainmenu:show()
		end,
		{
			description = "show main menu",
			group = "AwesomeWM",
		}
	),

	-- Audio control
	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
	end),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
	end),
	awful.key({}, "XF86AudioMute", function()
		awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
	end),
	awful.key({}, "XF86AudioPlay", function()
		awful.spawn("playerctl play-pause")
	end),
	awful.key({}, "XF86AudioStop", function()
		awful.spawn("playerctl pause")
	end),
	awful.key({}, "XF86AudioPrev", function()
		awful.spawn("playerctl previous")
	end),
	awful.key({}, "XF86AudioNext", function()
		awful.spawn("playerctl next")
	end),

	-- Brightness control
	awful.key({}, "XF86MonBrightnessUp", function()
		awful.spawn("brightnessctl set +10%")
	end),
	awful.key({}, "XF86MonBrightnessDown", function()
		awful.spawn("brightnessctl set 10%-")
	end),

	-- Apps
	awful.key(
		{ keys.modkey },
		keys.enter,
		function()
			awful.spawn(terminal)
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
		{ keys.modkey, keys.shift },
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
		{ keys.modkey, keys.shift },
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
		{ keys.modkey, keys.ctrl },
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
		{ keys.modkey, keys.ctrl },
		"k",
		function()
			awful.screen.focus_relative(-1)
		end,
		{
			description = "focus the previous screen",
			group = "screen",
		}
	),
	awful.key({ keys.modkey }, "u", awful.client.urgent.jumpto, {
		description = "jump to urgent client",
		group = "Window",
	}),
	awful.key(
		{ keys.modkey },
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
	awful.key({ keys.modkey, keys.ctrl }, "r", awesome.restart, {
		description = "Reload awesome",
		group = "AwesomeWM",
	}),
	awful.key(
		{ keys.modkey, keys.shift },
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
		{ keys.modkey },
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
		{ keys.modkey },
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
		{ keys.modkey, keys.shift },
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
		{ keys.modkey, keys.shift },
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
		{ keys.modkey, keys.ctrl },
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
		{ keys.modkey, keys.ctrl },
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
		{ keys.modkey },
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
		{ keys.modkey, keys.shift },
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
		{ keys.modkey, keys.ctrl },
		"n",
		function()
			local c = awful.client.restore()
			-- Focus restored client
			if c then
				c:emit_signal("request::activate", "key.unminimize", {
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
		{ keys.modkey },
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
		{ keys.modkey },
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
		-- Toggle tag on focused client.
		global_keys,
		-- View tag only.
		awful.key(
			{ keys.modkey },
			"#" .. i + 9,
			function()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					tag:view_only()
				end
			end,
			{
				description = "view tag #" .. i,
				group = "tag",
			}
		),
		-- Toggle tag display.
		awful.key(
			{ keys.modkey, keys.ctrl },
			"#" .. i + 9,
			function()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end,
			{
				description = "toggle tag #" .. i,
				group = "tag",
			}
		),
		-- Move client to tag.
		awful.key(
			{ keys.modkey, keys.shift },
			"#" .. i + 9,
			function()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
			end,
			{
				description = "move focused client to tag #" .. i,
				group = "tag",
			}
		),
		awful.key(
			{ keys.modkey, keys.ctrl, keys.shift },
			"#" .. i + 9,
			function()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end,
			{
				description = "toggle focused client on tag #" .. i,
				group = "tag",
			}
		)
	)
end

root.keys(global_keys)

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = rules(beautiful)


-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	if not awesome.startup then
		awful.client.setslave(c)
	end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end

	c.shape = function(cr, w, h)
		local border_radius = 12
		gears.shape.rounded_rect(cr, w, h, border_radius)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = gears.table.join(
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	awful.titlebar(c):setup{
		{
			-- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		{
			-- Middle
			{
				-- Title
				align = "center",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{
			-- Right
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.ontopbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal(),
		},
		layout = wibox.layout.align.horizontal,
	}
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

-- Strict focus, when a client under the mouse changes
client.connect_signal("mouse::move", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)
