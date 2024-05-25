local add = MiniDeps.add
require("ducharmemp.theme")
add("tpope/vim-sleuth")
add("tpope/vim-dadbod")
add("tpope/vim-fugitive")
add("tpope/vim-rhubarb")
add("folke/which-key.nvim")
require("which-key").setup()
require("ducharmemp.telescope")
require("ducharmemp.cmp")
require("ducharmemp.lsp")
require("ducharmemp.conform")
require("ducharmemp.mini")
require("ducharmemp.treesitter")
require("ducharmemp.delimiters")
require("ducharmemp.lint")
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
	render = "background",
	enable_named_colors = true,
	enable_tailwind = true,
})
add("rgroli/other.nvim")
require("other-nvim").setup({
	mappings = { "rails" },
})
add("stevearc/oil.nvim")
require("oil").setup()

vim.keymap.set("n", "<leader>oo", "<cmd>:Other<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>otn", "<cmd>:OtherTabNew<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>op", "<cmd>:OtherSplit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ov", "<cmd>:OtherVSplit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>oc", "<cmd>:OtherClear<CR>", { noremap = true, silent = true })
local openCommand = vim.fn.has("macunix") and "open" or "xdg-open"
vim.api.nvim_create_user_command("Browse", function(opts)
	vim.fn.system({ openCommand, opts.fargs[1] })
end, { nargs = 1 })

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
