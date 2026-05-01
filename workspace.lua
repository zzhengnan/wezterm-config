local wezterm = require("wezterm")
local module = {}

local act = wezterm.action

function module.apply_to_config(config)
	config.status_update_interval = 100 -- Update status every 100ms

	-- CTRL + SHIFT + w to choose among existing workspaces
	table.insert(config.keys, {
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
