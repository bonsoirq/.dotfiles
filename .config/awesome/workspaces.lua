local BUILT_IN_SCREEN_WORKSPACES = { "music", "other I", "other II", "steam" }
local EXTERNAL_SCREEN_WORKSPACES = { "web", "code", "cli", "mail", "chat" }

local WORKSPACES_BY_SCREEN =
	{ BUILT_IN_SCREEN_WORKSPACES, EXTERNAL_SCREEN_WORKSPACES }

return { by_screen = WORKSPACES_BY_SCREEN }