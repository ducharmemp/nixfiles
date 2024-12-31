local config = {
	lsps = {},
	formatters = {},
	linters = {},
	test = function(cursor_row) end,
	debug_configurations = {
		{
			name = "Debug",
			program = "rust-lldb",
		},
	},
}
return config
