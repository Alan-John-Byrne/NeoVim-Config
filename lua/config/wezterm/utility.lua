local json = require("lunajson")
local M = {}

function M.load_wezterm_config_props()
  local props
  --MAC
  local file = io.open(os.getenv("HOME") .. "/.config/nvim/lua/config/wezterm/props.json", 'r')
  --WINDOWS
  local file = io.open(os.getenv("USERPROFILE") .. "/AppData/Local/nvim/lua/config/wezterm/props.json", 'r')
  if file then
    local json_string = file:read('*all')
    file:close()
    props = json.decode(json_string)
    return props
  end
end

function M.save_wezterm_config_props(updated_config)
  --MAC
  local file = io.open(os.getenv("HOME") .. "/.config/nvim/lua/config/wezterm/props.json", 'r')
  --WINDOWS
  local file = io.open(os.getenv("USERPROFILE") .. "/AppData/Local/nvim/lua/config/wezterm/props.json", 'r')
  if file then
    file:write(json.encode(updated_config))
    file:close()
  end
end

return M
