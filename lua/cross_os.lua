-- INFO: Custom Cross-OS Compatibilty Utility Module.

---@class M
local M = {}

function M.os_detect()
  local os_type = vim.uv.os_uname()
  return os_type
end

return M
