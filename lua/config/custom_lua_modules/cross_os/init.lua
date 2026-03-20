--- IMPORTANT: Modules (classes / tables) and their functions use
--- an annotation called 'LuaCats', look it up (it's different from
--- 'EmmyLua'). Module full of random convenience functions.
-- WARN: LuaCat class and method 'descriptions' do NOT work correctly,
-- when adding to the global 'vim' module.
-- DON'T 'MONKEY PATCH' like this -> vim.method_name = function()!!!!
-- TODO: Do this instead -> vim.custom_module = M (i.e.: 'M' being the name of your module)
-- INFO: Custom Cross-OS Compatibilty Utility Module.

-- Custom CrossOS Compatibilty Module.
---@class CrossOS
local M = {}

function M.detect_os()
  local os_type = vim.uv.os_uname()
  return os_type.sysname
end

return M
