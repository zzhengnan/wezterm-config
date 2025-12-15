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
	config.key_tables["resize_pane"] = {
		resize_pane("h", "Left"),
		resize_pane("j", "Down"),
		resize_pane("k", "Up"),
		resize_pane("l", "Right"),
	}

	table.insert(config.keys, {
		-- LEADER + r to activate `resize_panes` key table
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
end

return module
