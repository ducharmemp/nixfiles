local add = MiniDeps.add
add("nvim-treesitter/nvim-treesitter")
add("nvim-treesitter/nvim-treesitter-textobjects")
add("RRethy/nvim-treesitter-endwise")

-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
	ensure_installed = { "html", "lua", "vim", "vimdoc" },
	-- Autoinstall languages that are not installed
	auto_install = true,
	highlight = { enable = true, additional_vim_regex_highlighting = false },
	indent = { enable = true }, 
	endwise = { enable = true },
})

-- There are additional nvim-treesitter modules that you can use to interact
-- with nvim-treesitter. You should go explore a few and see what interests you:
--
--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
