local add = MiniDeps.add

require("ducharmemp.theme")
add("tpope/vim-sleuth")
add("tpope/vim-dadbod")
add("tpope/vim-fugitive")
add("folke/which-key.nvim")
add("windwp/nvim-autopairs")
add({
	source = "folke/todo-comments.nvim",
	depends = { "nvim-lua/plenary.nvim" },
})
require("ducharmemp.telescope")
require("ducharmemp.cmp")
require("ducharmemp.lsp")
require("ducharmemp.conform")
require("ducharmemp.mini")
