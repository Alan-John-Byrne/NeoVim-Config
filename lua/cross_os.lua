-- INFO: Custom Cross-OS Compatibilty Utility Module.

---@class M
local M = {}

function M.detect_os()
  local os_type = vim.uv.os_uname()
  return os_type.sysname
end

return M
