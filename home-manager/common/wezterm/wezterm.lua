-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"
config.window_decorations = "RESIZE"
config.tab_bar_at_bottom = true
config.font_size = 12.0
config.font = wezterm.font("CommitMono Nerd Font")
-- config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.harfbuzz_features = { "ss03", "ss04", "ss05" }
config.colors = {
	tab_bar = {},
}

config.front_end = "WebGpu"
-- config.webgpu_power_preference = "HighPerformance"
config.enable_wayland = true
config.term = "wezterm"
config.exit_behavior = "CloseOnCleanExit"
config.keys = {
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
}

config.status_update_interval = 5000

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, _, _, conf, _, max_width)
	local palette = conf.resolved_palette
	local foreground = palette.foreground
	local background = palette.background
	if tab.is_active then
		background = palette.selection_bg
	end
	local title = tab_title(tab)

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	title = wezterm.truncate_right(title, (max_width or 8) - 2)

	return {
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
	}
end)

-- and finally, return the configuration to wezterm
return config
