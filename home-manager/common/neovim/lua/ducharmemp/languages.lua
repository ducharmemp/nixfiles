local Languages = {
	ruby = require("ducharmemp.languages.ruby"),
	rust = require("ducharmemp.languages.rust"),
	eruby = {
		lsps = { "erb-formatter" },
		formatters = { "erb_format", "injected" },
		linters = {},
	},
	typescript = {
		lsps = { "tsserver" },
		formatters = { "prettier" },
		linters = {},
	},
	javascript = {
		lsps = {},
		formatters = { "prettier" },
		linters = {},
	},
	python = {
		lsps = { "pyright" },
		formatters = { "isort", "black" },
		linters = {},
	},
	lua = {
		lsps = {
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							-- Tells lua_ls where to find all the Lua files that you have loaded
							-- for your neovim configuration.
							library = {
								"${3rd}/luv/library",
								unpack(vim.api.nvim_get_runtime_file("", true)),
							},
							-- If lua_ls is really slow on your computer, you can try this instead:
							-- library = { vim.env.VIMRUNTIME },
						},
						completion = {
							callSnippet = "Replace",
						},
						-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
						-- diagnostics = { disable = { 'missing-fields' } },
					},
				},
			},
		},
		formatters = { "stylua" },
		linters = {},
	},
	markdown = {
		lsps = {},
		formatters = {},
		linters = { "markdownlint" },
	},
}

return Languages
