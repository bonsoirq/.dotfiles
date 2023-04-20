-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local constants = require("constants")

-- Standard awesome library
local awful = require("awful")
local gears = require("gears")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local rules = require("rules")
local workspaces = require("workspaces")
local context_menu = require("context_menu")
local global_keys = require("global_keys")
local restore_wallpaper = require("restore_wallpaper")

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

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", restore_wallpaper)

awful.screen.connect_for_each_screen(function(screen)

-- Each screen has its own workspace table.

-- Create a promptbox for each screen
-- Create an imagebox widget which will contain an icon indicating which layout we're using.
-- We need one layoutbox per screen.
-- Create a taglist widget

-- Create a tasklist widget

-- Create the wibox

-- Add widgets to the wibox -- Left widgets -- Middle widget -- Right widgets
	restore_wallpaper()

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
