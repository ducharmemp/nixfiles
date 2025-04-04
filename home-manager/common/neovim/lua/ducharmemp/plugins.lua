local add = MiniDeps.add
require("ducharmemp.theme")
add("tpope/vim-sleuth")
add("tpope/vim-dadbod")
add("tpope/vim-fugitive")
add("tpope/vim-rhubarb")
add("direnv/direnv.vim")
require("ducharmemp.telescope")
require("ducharmemp.cmp")
require("ducharmemp.lsp")
require("ducharmemp.conform")
-- require("ducharmemp.debugging")
require("ducharmemp.testing")
require("ducharmemp.mini")
require("ducharmemp.treesitter")
require("ducharmemp.delimiters")
require("ducharmemp.lint")
require("ducharmemp.terminal")
require("ducharmemp.copilot")

add("lukas-reineke/indent-blankline.nvim")
local highlight = {
	"CursorColumn",
	"Whitespace",
}

require("ibl").setup({
	indent = { highlight = highlight, char = "" },
	whitespace = {
		highlight = highlight,
		remove_blankline_trail = false,
	},
	scope = { enabled = false },
})
add("brenoprata10/nvim-highlight-colors")
require("nvim-highlight-colors").setup({
	render = "virtual",
	enable_tailwind = true,
})
add({ source = "stevearc/oil.nvim" })
require("oil").setup({
	view_options = { show_hidden = true },
})
vim.keymap.set("n", "<leader>fb", ":Oil<CR>", { noremap = true, desc = "Open [F]ile [B]rowser" })

add("rgroli/other.nvim")
require("other-nvim").setup({
	mappings = { "rails" },
})
vim.keymap.set("n", "<leader>oo", "<cmd>:Other<CR>", { noremap = true, silent = true, desc = "Opens an[o]ther file" })
vim.keymap.set(
	"n",
	"<leader>ot",
	"<cmd>:OtherTabNew<CR>",
	{ noremap = true, silent = true, desc = "Opens an[o]ther file in a new [t]ab" }
)
vim.keymap.set(
	"n",
	"<leader>op",
	"<cmd>:OtherSplit<CR>",
	{ noremap = true, silent = true, desc = "Opens an[o]ther file in a new [p]ane" }
)
vim.keymap.set(
	"n",
	"<leader>ov",
	"<cmd>:OtherVSplit<CR>",
	{ noremap = true, silent = true, desc = "Opens an[o]ther file in a new [v]ertical split" }
)

local openCommand = vim.fn.has("macunix") and "open" or "xdg-open"
vim.api.nvim_create_user_command("Browse", function(opts)
	vim.fn.system({ openCommand, opts.fargs[1] })
end, { nargs = 1 })

add("folke/which-key.nvim")
require("which-key").setup()

add("kevinhwang91/nvim-bqf")
require("bqf").setup()

add("rcarriga/nvim-notify")
vim.notify = require("notify")

local handler = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = (" 󰁂 %d "):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, { suffix, "MoreMsg" })
	return newVirtText
end
add({
	source = "kevinhwang91/nvim-ufo",
	depends = {
		"kevinhwang91/promise-async",
	},
})
require("ufo").setup({
	fold_virt_text_handler = handler,
})

add("mbbill/undotree")
-- add("folke/flash.nvim")
-- require("flash").setup()
add("nvim-orgmode/orgmode")
require("orgmode").setup()

vim.cmd("DirenvExport")
-- {
-- 	"folke/flash.nvim",
-- 	event = "VeryLazy",
-- 	opts = {},
--    -- stylua: ignore
--    keys = {
--      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
--      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
--      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
--      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
--      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
--    },
-- },
