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
}

config.status_update_interval = 5000

return config
