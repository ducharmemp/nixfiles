local add, later = MiniDeps.add, MiniDeps.later
local MiniIcons = require("mini.icons")

local build = function(path)
	local obj = vim.system({ "make", "-C", path, "install_jsregexp" }, { text = true }):wait()
	vim.print(vim.inspect(obj))
end

add({
	source = "hrsh7th/nvim-cmp",
	depends = {
		"honza/vim-snippets",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"rafamadriz/friendly-snippets",
	},
})

add("windwp/nvim-autopairs")
require("nvim-autopairs").setup()
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

add({
	source = "L3MON4D3/LuaSnip",
	hooks = {
		post_install = function(args)
			later(function()
				build(args)
			end)
		end,
		post_checkout = build,
	},
})

local luasnip = require("luasnip")
luasnip.config.setup({})
vim.o.path = vim.o.path .. (vim.fn.stdpath("data") .. "/site/pack/deps/opt/vim-snippets")

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load()

cmp.setup({
	view = {
		entries = { name = "custom", selection_order = "near_cursor" },
	},
	formatting = {
		format = function(entry, item)
			local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
			local icon, hl, is_default = MiniIcons.get("lsp", item.kind)
			if not is_default then
				item.kind = icon .. " " .. item.kind
				item.kind_hl_group = hl
			end
			if color_item.abbr_hl_group then
				item.kind_hl_group = color_item.abbr_hl_group
				item.kind = color_item.abbr .. " " .. item.kind
			end
			return item
		end,
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	completion = { completeopt = "menu,menuone,noinsert" },

	-- For an understanding of why these mappings were
	-- chosen, you will need to read `:help ins-completion`
	--
	-- No, but seriously. Please read `:help ins-completion`, it is really good!
	mapping = cmp.mapping.preset.insert({
		-- Select the [n]ext item
		["<C-n>"] = cmp.mapping.select_next_item(),
		-- Select the [p]revious item
		["<C-p>"] = cmp.mapping.select_prev_item(),

		-- Accept ([y]es) the completion.
		--  This will auto-import if your LSP supports it.
		--  This will expand snippets if the LSP sent a snippet.
		["<C-y>"] = cmp.mapping.confirm({ select = true }),

		-- Manually trigger a completion from nvim-cmp.
		--  Generally you don't need this, because nvim-cmp will display
		--  completions whenever it has completion options available.
		["<C-Space>"] = cmp.mapping.complete({}),

		-- Think of <c-l> as moving to the right of your snippet expansion.
		--  So if you have a snippet that's like:
		--  function $name($args)
		--    $body
		--  end
		--
		-- <c-l> will move you to the right of each of the expansion locations.
		-- <c-h> is similar, except moving you backwards.
		["<C-l>"] = cmp.mapping(function()
			if luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			end
		end, { "i", "s" }),
		["<C-h>"] = cmp.mapping(function()
			if luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
	},
})
