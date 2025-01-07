local add = MiniDeps.add
add({ source = "CopilotC-Nvim/CopilotChat.nvim", depends = { "zbirenbaum/copilot.lua", "nvim-lua/plenary.nvim" } })
require("CopilotChat").setup({
	model = "claude-3.5-sonnet",
})
