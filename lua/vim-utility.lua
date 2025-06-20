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

--- Returns a table containing all the seperate strings.
---@param str string The string containing the 'split' pattern.
---@param pattern  string  The pattern to split at.
---@return string[] A table of strings
---@nodiscard
function M.split(str, pattern)
  local seperated_strings = {}
  for string in str:gmatch("[^" .. pattern .. ",]+") do
    table.insert(seperated_strings, string)
  end
  return seperated_strings
end

-- Exporting the module.
return M
