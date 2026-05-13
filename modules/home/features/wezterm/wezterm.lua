config.window_decorations = "RESIZE"
if wezterm.target_triple ~= "aarch64-apple-darwin" and wezterm.target_triple ~= "x86_64-apple-darwin" then
	config.window_background_opacity = 0.8
end
config.font_size = 12.0
config.font = wezterm.font("BerkeleyMonoNerdFont Nerd Font")
-- config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
-- config.harfbuzz_features = { "ss03", "ss04", "ss05" }
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
	{
		key = "d",
		mods = "CMD",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "d",
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "h",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "LeftArrow",
		mods = "CMD|CTRL",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "RightArrow",
		mods = "CMD|CTRL",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = "UpArrow",
		mods = "CMD|CTRL",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "DownArrow",
		mods = "CMD|CTRL",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
}

config.status_update_interval = 5000

return config
