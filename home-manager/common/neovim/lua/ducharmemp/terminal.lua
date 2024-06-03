local add = MiniDeps.add

add("willothy/wezterm.nvim")
local wezterm = require("wezterm")
local languages = require("ducharmemp.languages")
---@diagnostic disable-next-line: missing-parameter
wezterm.setup()

vim.keymap.set("n", "<leader>wt", function()
	local needs_new_split = wezterm.get_pane_direction("Down") == nil
	if needs_new_split then
		wezterm.split_pane.vertical({ percent = 20, top_level = true, bottom = true })
	else
		wezterm.switch_pane.direction("Down")
	end
end, { desc = "Spawn a [W]ez[T]erm split below your main window" })

vim.keymap.set("n", "<leader>tt", function()
	local filetype = vim.bo.filetype
	languages[filetype].test()
end)
