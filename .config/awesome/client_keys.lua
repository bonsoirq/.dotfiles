-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local keys = require("constants").keys

return gears.table.join(
	awful.key(
		{ keys.modkey },
		"f",
		function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end,
		{
			description = "toggle fullscreen",
			group = "Window",
		}
	),
	awful.key({ keys.modkey }, "q", function(c)
		c:kill()
	end),
	awful.key(
		{ keys.modkey, keys.shift },
		"c",
		function(c)
			c:kill()
		end,
		{
			description = "close",
			group = "Window",
		}
	),
	awful.key(
		{ keys.modkey, keys.ctrl },
		"space",
		awful.client.floating.toggle,
		{
			description = "toggle floating",
			group = "Window",
		}
	),
	awful.key(
		{ keys.modkey, keys.ctrl },
		"Return",
		function(c)
			c:swap(awful.client.getmaster())
		end,
		{
			description = "move to master",
			group = "Window",
		}
	),
	awful.key(
		{ keys.modkey },
		"o",
		function(c)
			c:move_to_screen()
		end,
		{
			description = "move to screen",
			group = "Window",
		}
	),
	awful.key(
		{ keys.modkey },
		"t",
		function(c)
			c.ontop = not c.ontop
		end,
		{
			description = "toggle keep on top",
			group = "Window",
		}
	),
	awful.key(
		{ keys.modkey },
		"n",
		function(c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end,
		{
			description = "minimize",
			group = "Window",
		}
	),
	awful.key(
		{ keys.modkey },
		"m",
		function(c)
			c.maximized = not c.maximized
			c:raise()
		end,
		{
			description = "(un)maximize",
			group = "Window",
		}
	),
	awful.key(
		{ keys.modkey, keys.ctrl },
		"m",
		function(c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end,
		{
			description = "(un)maximize vertically",
			group = "Window",
		}
	),
	awful.key(
		{ keys.modkey, keys.shift },
		"m",
		function(c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end,
		{
			description = "(un)maximize horizontally",
			group = "Window",
		}
	)
)