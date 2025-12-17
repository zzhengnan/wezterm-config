local wezterm = require("wezterm")
local module = {}

function module.apply_to_config(config)
	local key_binds = {
		-- Move between panes
		{ key = "h", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Left") },
		{ key = "j", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Down") },
		{ key = "k", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Up") },
		{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Right") },
		-- Move between tabs
		{ key = "h", mods = "ALT", action = wezterm.action.ActivateTabRelative(-1) },
		{ key = "l", mods = "ALT", action = wezterm.action.ActivateTabRelative(1) },
	}
	for _, key_bind in ipairs(key_binds) do
		table.insert(config.keys, key_bind)
	end
end

return module
