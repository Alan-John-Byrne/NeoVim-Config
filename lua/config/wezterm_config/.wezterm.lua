-- NOTE: Open the Debug menu using 'CTRL+SHIFT L'.
-- SECTION: STEP 0: WezTerm Specific Runtime Environment Setup.
-- TODO: Extend WezTerm's Lua runtime path (rtp = `package.path` [ and also `package.cpath` in the case of using macOS ]) to include
-- the LuaRocks-managed `luarock-modules` directory used by Neovim (this directory I've decided to store within NeoVims own directory
-- hierarchy / rtp). This directory is now the default location (tree root) that plugins will be installed to (configured via
-- `~/.config/luarocks/config.lua`) via the 'luarocks' package manager. Lua packages are installed here using the `--tree`. So,
-- instead of WezTerms own configuration. It's like Neovim sharing lua packages it uses, with WezTerm. This is where WezTerm will
-- load external libraries from. Therefore, both programs read from the same place for external custom lua packages, during
-- their own runtimes.
-- REMEMBER: The '.wezterm.lua' config file is a static lua script loaded only by the WezTerm program's
-- process during startup (or reloaded on a manual config reload). It is *NOT* a module and
-- cannot be 'required' by other programs like Neovim. The WezTerm and Neovim applications run
-- as their own completely separate processes and do not share memory or state — there is no
-- Inter-Process Communication (IPC). Therefore, changes to WezTerm must be done in its own
-- environment and reloaded explicitly. They have their own *COMPLETELY SEPERATE* embedded lua runtime environments.
-- IMPORTANT: The below steps *MUST* lines must be evaluated *BEFORE* any `require` statements for external Lua modules.
if io.open(os.getenv("HOME") .. "/.config/nvim/lua/config/wezterm_config/wezterm_utility.lua", "r") then
  -- OOO: macOS:
  local home = os.getenv("HOME")
  local nvim_dir = home .. "/.config/nvim/lua"
  local nvim_config_dir = nvim_dir .. "/config"
  local wezterm_dir = nvim_config_dir .. "/wezterm_config"
  local custom_nvim_lua_libraries = nvim_config_dir .. "/custom_nvim_lua_libraries"
  local luarocks_modules = nvim_dir .. "/luarock-modules"
  -- STEP: 1: Adding utility module(s) to prevent clutter. (Stored within the Neovim config files)
  package.path = package.path .. ";" .. wezterm_dir .. "/?.lua" .. ";" .. wezterm_dir .. "/?/init.lua"
  -- STEP: 2: Adding luarocks 'Lua' modules.
  package.path = package.path ..
      ";" ..
      luarocks_modules .. "/share/lua/5.4/?.lua" .. ";" .. luarocks_modules .. "/share/lua/5.4/?/init.lua"
  -- STEP: 3: Adding luarocks 'C' modules.
  package.cpath = package.cpath .. ";" .. luarocks_modules .. "/lib/lua/5.4/?.so"
  -- STEP: 4: Adding nvim configuration modules.
  package.path = package.path .. ";" .. nvim_config_dir .. "/?.lua" .. ";" .. nvim_config_dir .. "/?/init.lua"
  -- STEP: 5: Adding custom nvim lua libraries / modules.
  -- WARN: Any nvim configuration modules (lua modules that you've written within / are stored in your nvim config
  -- directory hierarchy that's included above) containing any 'vim' related module calls, will result in errors.
  -- As stated, WezTerm & NeoVim don't share the same runtime.
  package.path = package.path ..
      ";" .. custom_nvim_lua_libraries .. "/?.lua" .. ";" .. custom_nvim_lua_libraries .. "/?/init.lua"
elseif io.open(os.getenv("USERPROFILE") .. "/AppData/Local/nvim/lua/config/wezterm_config/wezterm_utility.lua", "r") then
  -- OOO: Windows:
  local user_profile = os.getenv("USERPROFILE")
  local nvim_dir = user_profile .. "/AppData/Local/nvim/lua"
  local nvim_config_dir = nvim_dir .. "/config"
  local wezterm_dir = nvim_config_dir .. "/wezterm_config"
  local luarocks_modules = nvim_config_dir .. "/luarock-modules"
  local custom_nvim_lua_libraries = nvim_config_dir .. "/custom_nvim_lua_libraries"
  -- STEP: 1: Adding utility module to prevent clutter. (Stored within the Neovim config files)
  package.path = package.path .. ";" .. wezterm_dir .. "/?.lua" .. ";" .. wezterm_dir .. "/?/init.lua"
  -- STEP: 2: Adding luarocks 'Lua' modules.
  package.path = package.path ..
      ";" ..
      luarocks_modules .. "/share/lua/5.1/?.lua" .. ";" .. luarocks_modules .. "/share/lua/5.1/?/?.lua"
  -- STEP: 3: Adding nvim configuration modules.
  package.path = package.path .. ";" .. nvim_dir .. "/?.lua" .. ";" .. nvim_dir .. "/?/init.lua"
  -- STEP: 4: Adding custom nvim lua libraries / modules.
  -- WARN: Any nvim configuration modules (lua modules that you've written within / are stored in your nvim config directory hierarchy that's included above)
  -- containing any 'vim' related module calls, will result in errors. As stated, WezTerm & NeoVim don't share the same runtime.
  package.path = package.path ..
      ";" .. custom_nvim_lua_libraries .. "/?.lua" .. ";" .. custom_nvim_lua_libraries .. "/?/init.lua"
end
-- ERROR: Prior to setting the appropriate runtime paths, avoid attempting to import ('require') any 'custom_libraries' that
-- you may have written outside of the standard embedded lua runtime environment that comes packaged with the WezTerm application.
-- Meaning, you can't include lua libraries / modules that are written elsewhere on your system (e.g.: your Neovim configuration).
-- When WezTerm boots up, it starts by looking for this '.wezterm.lua' configuration file, in which we first need to expand the 'search area'
-- to find these 'custom_libraries' / lua modules, and the embedded lua runtime can then include these custom libraries, so they can be used
-- within this very file.

-- SECTION: STEP 1: Creating the configuration.
local wezterm = require('wezterm') -- NOTE: Pull in the WezTerm API.
-- TODO: Instantiating the configuration builder.
-- (This is our wezterm configuration settings.)
-- IMPORTANT: Configuration Location: (MUST BE SET WITHIN GLOBAL SYSTEM ENVIRONMENT VARIABLES, NOT A PROFILE)
-- NOTE: Refer to the configuration options here -> https://wezterm.org/config/keys.html,
-- and the Lua Reference (API) here -> https://wezterm.org/config/lua/general.html.
local config = wezterm.config_builder()
config.set_environment_variables = {
  WEZTERM_CONFIG_FILE = "/.config/nvim/lua/config/wezterm_config/.wezterm.lua"
}

-- SECTION: STEP 2: Apply config preferences - Loading configuration (prop) options:
-- INFO: (Some taken from 'props.json' file)
local wezterm_utility = require("wezterm_utility")
local props = wezterm_utility.load_wezterm_config_props()
if props then -- If the options are available use them.
  config.adjust_window_size_when_changing_font_size = props.adjust_window_size_when_changing_font_size
  config.color_scheme = props.color_scheme
  config.colors = props.colors
  config.enable_scroll_bar = props.enable_scroll_bar
  config.font = wezterm.font_with_fallback({ -- Setting proper font families to fall back on if certain icons aren't available in some.
    { family = 'JetBrainsMono NFP',          weight = 'Light', italic = false, scale = 1 },
    { family = 'JetBrainsMono NF',           weight = 'Light', italic = false, scale = 1 },
    { family = 'Noto Sans Linear B Regular', weight = 'Light', italic = false, scale = 1 },
  })
  --INFO: It the current processes running.
  config.launch_menu = props.launch_menu -- TODO: Right click in the 'bufferline.nvim' bar to display the launch_menu.
  config.default_prog = props.default_prog
  config.window_background_opacity = props.window_background_opacity
  config.font_size = props.font_size
  -- IMPORTANT: MAC-OS SPECFIC SETTING.
  if wezterm_utility.find_os == "Darwin" then -- REMEMBER: We can't use the 'cross_os' module here, cause it uses the 'vim' global variable.
    config.macos_window_background_blur = props.macos_window_background_blur
  end
  -- WARN: DISABLING DEFAULT KEYBINDINGS THAT ARE EITHER INCOMPATIBLE.
  config.disable_default_key_bindings = props.disable_default_key_bindings
end

-- SECTION: STEP 3: Setting keybindings.
if wezterm_utility.find_os() == "Darwin" then
  -- INFO: 'ALT' maps to 'Option' on MAC.
  config.keys = require("mac_keys")
else
  config.keys = require("win_keys")
end

-- IMPORTANT: Finally, return the built configuration to WezTerm.
-- WARN: This is *NOT* accessible via Neovim as a Module. It's not included within Neovim's runtime.
return config
