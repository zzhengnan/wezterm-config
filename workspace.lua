local wezterm = require("wezterm")
local module = {}

-- https://wezterm.org/config/lua/keyassignment/SwitchToWorkspace.html#prompting-for-the-workspace-name
local act = wezterm.action
wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

function module.apply_to_config(config)
	table.insert(config.keys, {
		-- Choose among existing workspaces
		key = "w",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			-- Setting `action = wezterm.action.ShowLauncherArgs({ flags = "WORKSPACES" })` also works, but shows extraneous text.
			-- This custom solution is cleaner
			local workspaces = wezterm.mux.get_workspace_names()
			local choices = {}
			for _, name in ipairs(workspaces) do
				table.insert(choices, { label = name })
			end

			window:perform_action(
				act.InputSelector({
					title = "Workspaces",
					choices = choices,
					action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
						if label then
							inner_window:perform_action(act.SwitchToWorkspace({ name = label }), inner_pane)
						end
					end),
				}),
				pane
			)
		end),
	})

	-- LEADER + w to create new workspace
	table.insert(config.keys, {
		key = "w",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
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
