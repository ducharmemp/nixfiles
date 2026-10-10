local source = table.concat(vim.fn.readfile("modules/home/features/nvim/straps.nix"), "\n")
local setup = assert(source:match('(require%("straps"%).setup%(%{.-\n%s*}%))'))
setup = setup:gsub('%${builtins.toJSON config.age.secrets.llamacpp%-url.path}', '"${XDG_RUNTIME_DIR}/agenix/llamacpp-url"')
local mutation = vim.env.LLAMACPP_TEST_MUTATION
if mutation == "trim" then setup = setup:gsub("vim.trim", "tostring") end
if mutation == "expand" then setup = setup:gsub("vim.fn.expandcmd", "tostring") end
if mutation == "missing" then
  setup = setup:gsub("vim.fn.readfile", "(function(path) if vim.fn.filereadable(path) == 0 then return {} end return vim.fn.readfile(path) end)")
end
local directory = vim.fn.tempname()
local original_runtime = vim.env.XDG_RUNTIME_DIR
local original_straps = package.loaded.straps
local configured
package.loaded.straps = { setup = function(config) configured = config end }
vim.env.XDG_RUNTIME_DIR = directory
vim.fn.mkdir(directory .. "/agenix", "p")
local path = directory .. "/agenix/llamacpp-url"
local ok, err = pcall(function()
  vim.fn.writefile({ "  http://example.invalid:8080  " }, path)
  assert(loadstring(setup))()
  assert(configured.llamacpp_base_url == "http://example.invalid:8080", "runtime URL read, expansion or trim failed")
  vim.fn.delete(path)
  local readable = pcall(assert(loadstring(setup)))
  assert(not readable, "missing secret must raise an error")
end)
vim.env.XDG_RUNTIME_DIR = original_runtime
package.loaded.straps = original_straps
vim.fn.delete(directory, "rf")
if not ok then error(err) end
print("llamacpp secret tests passed")
