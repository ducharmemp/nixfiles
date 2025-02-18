local config = {
	lsps = { "solargraph", "rubocop" },
	formatters = {},
	linters = {},
	test = function(cursor_row)
		local current_file = vim.api.nvim_buf_get_name(0)
		local root_patterns = { ".bundle", "Gemfile" }
		local bundle_directory = vim.fs.dirname(vim.fs.find(root_patterns, { upward = true, path = current_file })[1])
		vim.notify("Running tests in context: " .. vim.inspect(bundle_directory))

		local files_to_test = {}
		if cursor_row ~= nil then
			files_to_test = { current_file .. ":" .. cursor_row }
		else
			files_to_test = { current_file }
		end

		if not string.find(current_file, "_spec.rb$") and not string.find(current_file, "_test.rb$") then
			files_to_test = vim.iter(require("other-nvim").findOther())
				:filter(function(spec)
					return spec.exists
				end)
				:map(function(spec)
					return spec.filename
				end)
				:totable()
		end

		return {
			"--cwd",
			bundle_directory,
			"--",
			"bundle",
			"exec",
			"rspec",
			vim.iter(files_to_test):join(" "),
		}
	end,
}

return config
