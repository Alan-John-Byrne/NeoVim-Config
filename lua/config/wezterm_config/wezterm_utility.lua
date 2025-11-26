local json = require("lunajson")
local M = {}

function M.find_os()
  local wezterm = require('wezterm')
  local triple = wezterm.target_triple
  local IS_MAC = triple:find("darwin") ~= nil
  if IS_MAC then
    return "Darwin"
  else
    return "Windows"
  end
end

function M.load_wezterm_config_props()
  local file = nil
  if M.find_os() == "Darwin" then
    print("hello")
    -- OOO: Mac:
    file = io.open(os.getenv("HOME") .. "/.config/nvim/lua/config/wezterm_config/mac_props.json", 'r')
  else
    -- OOO: Windows:
    file = io.open(os.getenv("USERPROFILE") .. "/AppData/Local/nvim/lua/config/wezterm_config/win_props.json", 'r')
  end
  if file then
    local json_string = file:read('*all')
    file:close()
    local props = json.decode(json_string)
    return props
  end
end

function M.save_wezterm_config_props(updated_config)
  local file = nil
  if M.find_os() == "Darwin" then
    -- OOO: Mac:
    file = io.open(os.getenv("HOME") .. "/.config/nvim/lua/config/wezterm_config/props.json", 'r')
  else
    -- OOO: Windows:
    file = io.open(os.getenv("USERPROFILE") .. "/AppData/Local/nvim/lua/config/wezterm_config/props.json", 'r')
  end
  if file then
    file:write(json.encode(updated_config))
    file:close()
  end
end

return M
