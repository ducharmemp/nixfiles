local add = MiniDeps.add
local Languages = require("ducharmemp.languages")
add("stevearc/conform.nvim")
local conform = require("conform")

local formatters = {}
for k, v in pairs(Languages) do
	formatters[k] = v.formatters
end

local slow_format_filetypes = {}
conform.setup({
	notify_on_error = false,
	format_on_save = function(bufnr)
		if slow_format_filetypes[vim.bo[bufnr].filetype] then
			return
		end
		local function on_format(err)
			if err and err:match("timeout$") then
				slow_format_filetypes[vim.bo[bufnr].filetype] = true
			end
		end

		return { timeout_ms = 200, lsp_fallback = true }, on_format
	end,

	format_after_save = function(bufnr)
		if not slow_format_filetypes[vim.bo[bufnr].filetype] then
			return
		end
		return { lsp_fallback = true }
	end,
	formatters_by_ft = formatters,
})
