local wezterm = require("wezterm")
local module = {}

local function resize_pane(key, direction)
	return {
		key = key,
		action = wezterm.action.AdjustPaneSize({ direction, 3 }),
	}
end

-- Define function in the `module` table.
-- Only functions defined in `module` will be exported to code that imports this module
-- The suggested convention for making modules that update the config is for them to export an
-- `apply_to_config` function that accepts the config object
function module.apply_to_config(config)
	local key_binds = {
		-- Split into new pane
		{ key = ":", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = '"', mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	}
	for _, key_bind in ipairs(key_binds) do
		table.insert(config.keys, key_bind)
	end

	-- https://alexplescan.com/posts/2024/08/10/wezterm/
	-- LEADER + r to activate `resize_panes` key table
	table.insert(config.keys, {
		key = "r",
		mods = "LEADER",
		action = wezterm.action.ActivateKeyTable({
			name = "resize_pane",
			-- Ensure key table stays active after it handles first key press
			one_shot = false,
			-- Deactivate key table after timeout
			timeout_milliseconds = 500,
		}),
	})
	config.key_tables["resize_pane"] = {
		resize_pane("h", "Left"),
		resize_pane("j", "Down"),
		resize_pane("k", "Up"),
		resize_pane("l", "Right"),
	}
end

return module
