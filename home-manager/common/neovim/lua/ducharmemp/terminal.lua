local add = MiniDeps.add

add("willothy/wezterm.nvim")
local wezterm = require("wezterm")
local languages = require("ducharmemp.languages")
---@diagnostic disable-next-line: missing-parameter
wezterm.setup()

local last_command = nil
local wezterm_spawn = { "cli", "split-pane", "--right", "--percent", "15" }

local function err(e)
	vim.notify("Wezterm failed to " .. e, vim.log.levels.ERROR, {
		title = "Wezterm",
	})
end

local function exit_handler(msg)
	---@param obj vim.SystemCompleted
	return function(obj)
		if obj.code ~= 0 then
			err(msg)
		end
	end
end

local function concat(t1, t2)
	local t3 = { unpack(t1) }
	for I = 1, #t2 do
		t3[#t1 + I] = t2[I]
	end
	return t3
end

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
	local cursor_row, _cursor_col = unpack(vim.api.nvim_win_get_cursor(0))

	---@diagnostic disable-next-line: redundant-parameter
	last_command = languages[filetype].test(cursor_row)
	local pane_id = wezterm.get_pane_direction("Right")
	if pane_id ~= nil then
		wezterm.exec_sync({ "cli", "kill-pane", "--pane-id", string.format("%d", pane_id) })
	end
	wezterm.exec(concat(wezterm_spawn, last_command), exit_handler("split pane"))
end, { desc = "Run tests closest to cursor" })

vim.keymap.set("n", "<leader>tf", function()
	local filetype = vim.bo.filetype
	last_command = languages[filetype].test()
	local pane_id = wezterm.get_pane_direction("Right")
	if pane_id ~= nil then
		wezterm.exec_sync({ "cli", "kill-pane", "--pane-id", string.format("%d", pane_id) })
	end
	wezterm.exec(concat(wezterm_spawn, last_command), exit_handler("split pane"))
end, { desc = "Run tests for whole file" })

vim.keymap.set("n", "<leader>tr", function()
	local pane_id = wezterm.get_pane_direction("Right")
	if pane_id ~= nil then
		wezterm.exec_sync({ "cli", "kill-pane", "--pane-id", string.format("%d", pane_id) })
	end
	wezterm.exec(concat(wezterm_spawn, last_command), exit_handler("split pane"))
end, { desc = "Repeat last test command" })
