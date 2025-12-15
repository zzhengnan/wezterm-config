local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Dark+"
-- config.default_prog = {}

config.font = wezterm.font("RobotoMono Nerd Font")
config.font_size = 14
config.window_background_opacity = 0.9

-- Remove window title
config.window_decorations = "RESIZE"

-- Shift + Tab as <leader>
config.leader = { key = "Space", mods = "SHIFT", timeout_milliseconds = 1000 }

-- Will be filled in later
config.key_tables = {}

-- https://wezterm.org/config/lua/keyassignment/SwitchToWorkspace.html#prompting-for-the-workspace-name
local act = wezterm.action
wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

config.keys = {
	-- Prompt for a name to use for a new workspace and switch to it.
	{
		key = "W",
		mods = "CTRL|SHIFT",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
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
	},
	{
		key = "Z",
		mods = "CTRL|SHIFT",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "%",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = '"',
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	-- {
	-- 	-- LEADER + r to activate `resize_panes` key table
	-- 	key = "r",
	-- 	mods = "LEADER",
	-- 	action = wezterm.action.ActivateKeyTable({
	-- 		name = "resize_panes",
	-- 		-- Ensure key table stays active after it handles first key press
	-- 		one_shot = false,
	-- 		-- Deactivate key table after timeout
	-- 		timeout_milliseconds = 1000,
	-- 	}),
	-- },
}

local helpers = require("resize_panes")
helpers.apply_to_config(config)
return config

-- return config
