local wezterm = require("wezterm")
local config = wezterm.config_builder()

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "C:\\Program Files\\Git\\bin\\bash.exe", "-i" }
	config.font_size = 10
else
	config.font_size = 16
end

config.color_scheme = "tokyonight"
config.default_cursor_style = "BlinkingBar"
config.font = wezterm.font("JetBrains Mono")
config.inactive_pane_hsb = {
	-- Decrease brightness for inactive panes
	brightness = 0.2,
}
config.use_fancy_tab_bar = true
config.window_background_opacity = 0.9
config.window_decorations = "RESIZE" -- Remove window title

-- SHIFT + Space as <leader>
config.leader = { key = "Space", mods = "SHIFT", timeout_milliseconds = 1000 }

-- These will be passed into and modified by helper modules later
config.keys = {}
config.key_tables = {}

-- Custom tab title: Current working directory plus # of panes in current tab, with padding on either side
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	-- TODO: Don't use full path
	local title = tab.active_pane.current_working_dir.file_path

	-- Use `mux` to handle pane count correctly for when a pane is zoomed in
	local num_panes = #wezterm.mux.get_tab(tab.tab_id):panes()

	local pad = "          "
	title = pad .. title .. pad
	if num_panes > 1 then
		title = title .. num_panes
	end

	return title
end)

require("navigation").apply_to_config(config)
require("pane").apply_to_config(config)
require("workspace").apply_to_config(config)

return config
