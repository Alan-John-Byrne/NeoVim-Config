--- IMPORTANT: Modules (classes / tables) and their functions use an annotation called 'LuaCats', look it up.
--- Module full of random convenience functions.
---@class M
local M = {}

--- Inserts a substring into a specified position of another string.
--- Returns the new string (where `str2` is inserted into `str1`). MUST BE USED.
---@param str1  string  The original string.
---@param str2  string  The substring to be inserted.
---@param pos   integer The position in the original string, where the new substring will be inserted into.
---@return string
---@nodiscard  NOTE: You must use the string returned from this function.
function M.insert(str1, str2, pos)
  return str1:sub(1, pos) .. str2 .. str1:sub(pos + 1)
end

--- Gets / returns the Mason package path as a string.
--- Returns a string, which is the name of the package installed via mason.
---@param package_name  string  The name of the package.
---@return string
---@nodiscard
function M.get_mason_package_path(package_name)
  local mason_registry = require("mason-registry") -- IMPORTANT: The mason registry only lists the LOADED plugins.
  local package = mason_registry.get_package(package_name)
  return package:get_install_path() -- We need to retrieve the path of where the package is installed, because it will contain everything we need.
end

-- Exporting the module.
return M
