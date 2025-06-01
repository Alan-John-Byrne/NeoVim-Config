--- INFO:  A set of utility methods for making configuring programming language support in Neovim, easier.
---@class M
local M = {}
--- Gets / returns the Mason package path as a string.
--- Returns a string, which is the name of the package installed via mason.
---@param package_name  string  The name of the package.
---@return string
---@nodiscard
function M.get_mason_package_path(package_name)
  return string.format(vim.fn.expand("$MASON/packages/%s"), package_name)
end

-- Exporting the module.
return M
