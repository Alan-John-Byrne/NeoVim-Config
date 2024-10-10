-- WARN: Adding to Neovim's package path for requiring modules easily:
-- NOTE: Adding path to package path so require can see modules I create. '?' is a wildcard for any set of characters.
package.path = package.path .. ";C:\\Users\\alanj\\AppData\\Local\\nvim\\lua\\custom\\my_functions.lua"

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

-- Exporting the module.
return M
