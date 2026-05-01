local wezterm = require("wezterm")
local module = {}

wezterm.on("format-tab-title", function(tab)
	-- When multiple panes are open and one is zoomed, append a directional arrow indicating
	-- which side the hidden pane(s) are on:
	--   → = active pane is leftmost
	--   ← = active pane is not leftmost

	local title = tab.tab_title ~= "" and tab.tab_title or tab.active_pane.title

	-- Use `mux` to handle pane count correctly for when a pane is zoomed in
	local num_panes = #wezterm.mux.get_tab(tab.tab_id):panes()

	local pad = "          "
	title = pad .. title .. pad

	if num_panes == 1 then
		return title
	end

	-- Find active pane
	local active_pane = nil
	local active_pane_id = tab.active_pane.pane_id
	local all_panes = wezterm.mux.get_tab(tab.tab_id):panes_with_info()
	for _, current_pane in ipairs(all_panes) do
		if current_pane.pane:pane_id() == active_pane_id then
			active_pane = current_pane
			break
		end
	end

	if active_pane.is_zoomed then
		local arrow = active_pane.left == 0 and "→" or "←"
		title = title .. arrow .. pad
	end

	return title
end)

function module.apply_to_config(config)
	table.insert(config.keys, {
		key = "t",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Enter tab name:",
			action = wezterm.action_callback(function(window, pane, line)
				if line and line ~= "" then
					window:active_tab():set_title(line)
				end
			end),
		}),
	})
end

return module
