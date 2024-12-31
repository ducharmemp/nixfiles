local terminal = require("ducharmemp.terminal")
local last_command = nil

vim.keymap.set("n", "<leader>tt", function()
	local filetype = vim.bo.filetype
	local cursor_row, _cursor_col = unpack(vim.api.nvim_win_get_cursor(0))

	---@diagnostic disable-next-line: redundant-parameter
	last_command = languages[filetype].test(cursor_row)
	terminal.exec_in_side_pane(last_command)
end, { desc = "Run tests closest to cursor" })

vim.keymap.set("n", "<leader>tf", function()
	local filetype = vim.bo.filetype
	last_command = languages[filetype].test()
	terminal.exec_in_side_pane(last_command)
end, { desc = "Run tests for whole file" })

vim.keymap.set("n", "<leader>tr", function()
	terminal.exec_in_side_pane(last_command)
end, { desc = "Repeat last test command" })
