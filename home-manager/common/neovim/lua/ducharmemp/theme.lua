local add = MiniDeps.add
add("catppuccin/nvim")
require("catppuccin").setup({
	flavor = 'mocha',
	integrations = {
		cmp = true,
		treesitter = true,
		mini = { enabled = true },
		indent_blankline = { enabled = true },
		mason = true,
		rainbow_delimiters = true,
		telescope = { enabled = true },
		which_key = true
	}
})
vim.cmd.colorscheme("catppuccin")
