local awful = require("awful")
local constants = require("constants")
local context_menu = require("context_menu")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
local xrandr = require("xrandr")

local _global_keys = gears.table.join(
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
	_global_keys = gears.table.join(
		-- Toggle workspace on focused client.
		_global_keys,
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

return _global_keys