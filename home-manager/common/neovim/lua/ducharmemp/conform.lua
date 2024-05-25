local add = MiniDeps.add
local Languages = require("ducharmemp.languages")
add("stevearc/conform.nvim")
local conform = require("conform")

local formatters = {}
for k, v in pairs(Languages) do
	formatters[k] = v.formatters
end

conform.setup({
	notify_on_error = false,
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
	formatters_by_ft = formatters,
})

conform.formatters.prettier = {
	options = {
		ft_parsers = {
			eruby = "html",
		},
	},
}
