local wezterm = require("wezterm")
local config = wezterm.config_builder()

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "C:\\Program Files\\Git\\bin\\bash.exe", "-li" }
	config.font_size = 10
else
	config.font_size = 14
end

config.color_scheme = "Dark+"
config.font = wezterm.font("RobotoMono Nerd Font")
config.window_background_opacity = 0.9
config.window_decorations = "RESIZE" -- Remove window title

-- SHIFT + Space as <leader>
config.leader = { key = "Space", mods = "SHIFT", timeout_milliseconds = 1000 }

-- Will be filled in later
config.key_tables = {}

config.keys = {
	{
		key = "z",
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
}

local resize_pane = require("resize_pane")
resize_pane.apply_to_config(config)

local create_workspace = require("create_workspace")
create_workspace.apply_to_config(config)

return config
