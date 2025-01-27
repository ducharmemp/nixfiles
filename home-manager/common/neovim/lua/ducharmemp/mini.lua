require("mini.hipatterns").setup({
	highlighters = {
		fixme = { pattern = "%f[%w]()[Ff][Ii][Xx][Mm][Ee]()%f[%W]", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w]()[Hh][Aa][Cc][Kk]()%f[%W]", group = "MiniHipatternsHack" },
		note = { pattern = "%f[%w]()[Nn][Oo][Tt][Ee]()%f[%W]", group = "MiniHipatternsNote" },
		todo = { pattern = "%f[%w]()[Tt][Oo][Dd][Oo]()%f[%W]", group = "MiniHipatternsTodo" },
	},
})

-- Better Around/Inside textobjects
--
-- Exampless
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [']quote
--  - ci'  - [C]hange [I]nside [']quote
local spec_treesitter = require("mini.ai").gen_spec.treesitter
local gen_ai_spec = require("mini.extra").gen_ai_spec
require("mini.ai").setup({
	n_lines = 500,
	custom_textobjects = {
		F = spec_treesitter({
			a = "@function.outer",
			i = "@function.inner",
		}),
		o = spec_treesitter({
			a = { "@conditional.outer", "@loop.outer" },
			i = { "@conditional.inner", "@loop.inner" },
		}),
		D = gen_ai_spec.diagnostic(),
		I = gen_ai_spec.indent(),
		L = gen_ai_spec.line(),
		N = gen_ai_spec.number(),
		G = gen_ai_spec.buffer(),
	},
})

-- Simple and easy statuline.
--  You could remove this setup call if you don't like it,
--  and try some other statusline plugin
local statusline = require("mini.statusline")
-- set use_icons to true if you have a Nerd Font
statusline.setup({ use_icons = vim.g.have_nerd_font })

-- You can configure sections in the statusline by overriding their
-- default behavior. For example, here we set the section for
-- cursor location to LINE:COLUMN
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
	return "%2l:%-2v"
end

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_git = function()
	local branch_name = vim.fn.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" })
	branch_name = branch_name:match("^%s*(.-)%s*$")
	if branch_name == "" or branch_name == "HEAD" then
		branch_name = vim.split(vim.fn.system({ "git", "status" }), "\r?\n")[1]
		branch_name = branch_name:match("^%s*(.-)%s*$")
	end
	return branch_name
end

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require("mini.surround").setup()
require("mini.sessions").setup()
require("mini.splitjoin").setup()
require("mini.icons").setup()

local art = [[
   ▄   ▄███▄   ████▄  ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄
    █  █▀   ▀  █   █ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄
██   █ ██▄▄    █   █ ███    ███ ███▌ ███   ███   ███
█ █  █ █▄   ▄▀ ▀████ ███    ███ ███▌ ███   ███   ███
█  █ █ ▀███▀         ███    ███ ███  ███   ███   ███
█   ██                ▀██████▀  █▀    ▀█   ███   █▀
]]

local header = function()
	local hour = tonumber(vim.fn.strftime("%H"))
	-- [04:00, 12:00) - morning, [12:00, 20:00) - day, [20:00, 04:00) - evening
	local part_id = math.floor((hour + 4) / 8) + 1
	local day_part = ({ "evening", "morning", "afternoon", "evening" })[part_id]
	local username = vim.loop.os_get_passwd()["username"] or "USERNAME"

	return art .. "\n\n" .. ("Good %s, %s"):format(day_part, username)
end

require("mini.starter").setup({
	header = header,
})
