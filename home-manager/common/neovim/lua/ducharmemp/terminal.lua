local add = MiniDeps.add

add("willothy/wezterm.nvim")
local wezterm = require("wezterm")
wezterm.setup()

vim.keymap.set("n", "<leader>ts", function()
	local needs_new_split = wezterm.get_pane_direction("Down") == nil
	if needs_new_split then
		wezterm.split_pane.vertical({ percent = "20", top_level = true, bottom = true })
	else
		wezterm.switch_pane.direction("Down")
	end
end, { desc = "Spawn a terminal" })
