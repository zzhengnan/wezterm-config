local wezterm = require("wezterm")
local config = wezterm.config_builder()

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "C:\\Program Files\\Git\\bin\\bash.exe", "-li" }
	config.font_size = 10
else
	config.font_size = 14
end

config.color_scheme = "Dark+"
config.font = wezterm.font("JetBrains Mono")
-- config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" } -- Disable ligature
config.window_background_opacity = 0.9
config.window_decorations = "RESIZE" -- Remove window title

-- SHIFT + Space as <leader>
config.leader = { key = "Space", mods = "SHIFT", timeout_milliseconds = 1000 }

-- These will be passed into and modified by helper modules later
config.keys = {}
config.key_tables = {}

require("navigation").apply_to_config(config)
require("pane").apply_to_config(config)
require("workspace").apply_to_config(config)

return config
