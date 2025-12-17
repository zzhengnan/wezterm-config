local wezterm = require("wezterm")
local module = {}

-- https://wezterm.org/config/lua/keyassignment/SwitchToWorkspace.html#prompting-for-the-workspace-name
local act = wezterm.action
wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

function module.apply_to_config(config)
	-- LEADER + l to show existing workspaces
	table.insert(config.keys, {
		key = "l",
		mods = "LEADER",
		action = wezterm.action.ShowLauncherArgs({ flags = "WORKSPACES" }),
	})

	-- LEADER + w to create new workspace
	table.insert(config.keys, {
		key = "w",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace:" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	})
end

return module
