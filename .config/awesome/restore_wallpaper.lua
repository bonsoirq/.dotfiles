local awful = require("awful")

return function()
	awful.spawn("nitrogen --restore")
end