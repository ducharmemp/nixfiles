-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("IosevkaTerm Nerd Font Mono")
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.front_end = "WebGpu"
-- config.webgpu_power_preference = "HighPerformance"
config.enable_wayland = true
config.set_environment_variables = {
	TERMINFO_DIRS = "$HOME/.nix-profile/share/terminfo",
	WSLENV = "TERMINFO_DIRS",
}
config.term = "wezterm"
config.exit_behavior = "CloseOnCleanExit"
config.keys = {
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
}

-- and finally, return the configuration to wezterm
return config
