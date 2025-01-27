-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Macchiato"
config.window_decorations = "RESIZE"
config.tab_bar_at_bottom = true
config.font_size = 14.0
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
wezterm.on("update-status", function(window, _)
	local SOLID_LEFT_ARROW = ""
	local success, stdout, stderr =
		wezterm.run_child_process({ os.getenv("SHELL"), "-c", "spotify_player get key playback" })
	print("stdout", stdout)
	print("stderr", stderr)
	print("success", success)
	local parsed = wezterm.json_parse(stdout)
	local playing_item = "No music playing"
	local artists = ""
	if parsed ~= nil then
		playing_item = parsed["item"]["name"]
		for i, artist in ipairs(parsed["item"]["artists"]) do
			artists = artists .. artist["name"]
			if i < #parsed["item"]["artists"] then
				artists = artists .. ", "
			end
		end
	end

	local formatted_segment = playing_item

	if artists ~= "" then
		formatted_segment = playing_item .. " | " .. artists
	end
	local segments = {
		wezterm.strftime("%a %b %d %H:%M"),
		formatted_segment,
		wezterm.hostname(),
	}
	local color_scheme = window:effective_config().resolved_palette
	-- Note the use of wezterm.color.parse here, this returns
	-- a Color object, which comes with functionality for lightening
	-- or darkening the colour (amongst other things).
	local bg = wezterm.color.parse(color_scheme.background)
	local fg = color_scheme.foreground

	-- Each powerline segment is going to be coloured progressively
	-- darker/lighter depending on whether we're on a dark/light colour
	-- scheme. Let's establish the "from" and "to" bounds of our gradient.
	local gradient_to, gradient_from = bg
	gradient_from = gradient_to:lighten(0.2)

	-- Yes, WezTerm supports creating gradients, because why not?! Although
	-- they'd usually be used for setting high fidelity gradients on your terminal's
	-- background, we'll use them here to give us a sample of the powerline segment
	-- colours we need.
	local gradient = wezterm.color.gradient(
		{
			orientation = "Horizontal",
			colors = { gradient_from, gradient_to },
		},
		#segments -- only gives us as many colours as we have segments.
	)

	-- We'll build up the elements to send to wezterm.format in this table.
	local elements = {}

	for i, seg in ipairs(segments) do
		local is_first = i == 1

		if is_first then
			table.insert(elements, { Background = { Color = "none" } })
		end
		table.insert(elements, { Foreground = { Color = gradient[i] } })
		table.insert(elements, { Text = SOLID_LEFT_ARROW })

		table.insert(elements, { Foreground = { Color = fg } })
		table.insert(elements, { Background = { Color = gradient[i] } })
		table.insert(elements, { Text = " " .. seg .. " " })
	end

	window:set_right_status(wezterm.format(elements))
end)

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
