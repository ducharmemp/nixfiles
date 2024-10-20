local add = MiniDeps.add
add("mfussenegger/nvim-dap")
add({
	source = "rcarriga/nvim-dap-ui",
	depends = {
		"nvim-neotest/nvim-nio",
		"mfussenegger/nvim-dap",
	},
})
local Languages = require("ducharmemp.languages")
local dap = require("dap")
local dapui = require("dapui")

dap.adapters.lldb = {
	type = "executable",
	command = "lldb-dap",
	name = "lldb",
}

local configurations = {}

for k, v in pairs(Languages) do
	configurations[k] = v.debug_configurations
end

dap.configurations = configurations

dapui.setup()
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end
