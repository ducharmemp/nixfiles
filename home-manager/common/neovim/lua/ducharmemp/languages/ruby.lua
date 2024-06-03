local function err(e)
	vim.notify("Wezterm failed to " .. e, vim.log.levels.ERROR, {
		title = "Wezterm",
	})
end

---@private
local function exit_handler(msg)
	---@param obj vim.SystemCompleted
	return function(obj)
		if obj.code ~= 0 then
			err(msg)
		end
	end
end
local config = {
	lsps = { "ruby_lsp", "rubocop" },
	formatters = {},
	linters = {},
	test = function()
		local wezterm = require("wezterm")
		local current_file = vim.api.nvim_buf_get_name(0)
		local cursor_row, _cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
		local bundle_directory =
			vim.fn.fnamemodify(string.gsub(vim.fn.findfile("Gemfile", ".;"), "/Gemfile$", ""), ":p")
		vim.notify(vim.inspect(bundle_directory))

		local files_to_test = { current_file .. ":" .. cursor_row }
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
		local pane_id = wezterm.get_pane_direction("Right")
		if pane_id ~= nil then
			wezterm.exec_sync({ "cli", "kill-pane", "--pane-id", string.format("%d", pane_id) })
		end

		wezterm.exec({
			"cli",
			"split-pane",
			"--right",
			"--percent",
			"15",
			"--cwd",
			bundle_directory,
			"--",
			"bundle",
			"exec",
			"rspec",
			vim.iter(files_to_test):join(" "),
		}, exit_handler("split pane"))
	end,
}

return config
