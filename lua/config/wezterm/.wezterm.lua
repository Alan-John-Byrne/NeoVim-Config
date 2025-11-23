-- Open the Debug menu using 'CTRL+SHIFT L'.
-- SECTION: STEP 0: Environment Setup - Loading configuration (prop) options.
-- INFO:(MAC) Extend WezTerm's Lua runtime path (rtp = `package.path` and `package.cpath`) to include...
-- INFO:(WINDOWS) Extend WezTerm's Lua runtime path (rtp = `package.path`) to include...
-- the LuaRocks-managed `luarock-modules` directory used by Neovim (also included within Neovims own rtp).
-- This directory is now the default location (tree root) that plugins will be installed to (configured via
-- `~/.config/luarocks/config.lua`) via the 'luarocks' package manager. Lua packages are installed here using
-- the `--tree`. So, instead of WezTerms own configuration. It's like Neovim sharing lua packages it uses, with
-- WezTerm. This is where WezTerm will load external libraries from. Therefore, both programs read from the same
-- place for external custom lua packages, during their own runtimes.

-- IMPORTANT: (MAC)These lines must be evaluated *before* any `require` statements for external Lua modules.
local luarocks_nvim_wezterm_path = os.getenv("HOME") .. "/.config/nvim/lua/luarock-modules"
package.path = package.path ..
    ";" ..
    luarocks_nvim_wezterm_path ..
    "/share/lua/5.4/?.lua;" .. luarocks_nvim_wezterm_path .. "/share/lua/5.4/?/init.lua" .. ";"
package.cpath = package.cpath .. ";" .. luarocks_nvim_wezterm_path .. "/lib/lua/5.4/?.so"
-- REMEMBER: The '.wezterm.lua' config file is a static lua script loaded only by the
-- WezTerm program's process during startup (or a manual config reload). It is *NOT* a module and
-- cannot be 'required' by other programs like Neovim. The WezTerm and Neovim applications run
-- as their own completely separate processes and do not share memory or state — there is no
-- Inter-Process Communication (IPC). Therefore, changes to WezTerm must be done in its
-- environment and reloaded explicitly.
-- NOTE: Adding utility module to prevent clutter. (Stored within the Neovim config files)
local nvim_wezterm_utility_path = os.getenv("HOME") .. "/.config/nvim/lua/config/wezterm/utility.lua"

-- IMPORTANT: (WINDOWS)These lines must be evaluated *BEFORE* any `require` statements for external Lua modules.
local lua_rocks_nvim_wezterm_path = os.getenv("USERPROFILE") .. "/AppData/Local/nvim/lua/luarock-modules"
package.path = package.path ..
    ";" .. lua_rocks_nvim_wezterm_path .. "/share/lua/5.1/?.lua" ..
    ";" .. lua_rocks_nvim_wezterm_path .. "/share/lua/5.1/?/?.lua"
-- REMEMBER: The '.wezterm.lua' config file is a static lua script loaded only by the
-- WezTerm program's process, during startup (or a manual config reload). It is *NOT* a module and
-- cannot be 'required' by other programs like Neovim. The WezTerm and Neovim applications run
-- as their own completely separate processes and do not share memory or state — there is no
-- Inter-Process Communication (IPC). Therefore, changes to WezTerm must be done in its own
-- environment and reloaded explicitly.
-- NOTE: Adding utility module to prevent clutter (stored within the Neovim config files).
local nvim_wezterm_utility_path = os.getenv("USERPROFILE") .. "/AppData/Local/nvim/lua/config/wezterm/utility.lua"

package.path = package.path .. ";" .. nvim_wezterm_utility_path
local props = require("utility").load_wezterm_config_props()

-- SECTION: STEP 1: Initial Setup.
local wezterm = require('wezterm') -- NOTE: Pull in the WezTerm API.
-- TODO: Instantiating the configuration builder.
-- (This is our wezterm configuration settings.)
-- IMPORTANT: Configuration Location: (MUST BE SET WITHIN GLOBAL SYSTEM ENVIRONMENT VARIABLES, NOT A PROFILE)
-- NOTE: Refer to the configuration options here -> https://wezterm.org/config/keys.html,
-- and the Lua Reference (API) here -> https://wezterm.org/config/lua/general.html.
local config = wezterm.config_builder()

-- SECTION: STEP 2: Apply config preferences: (Some taken from 'props.json' file)
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

  -- IMPORTANT: MAC-OS SPECFIC SETTINGS.
  -- NOTE: Right click any tab in the top bar to display the 'launch_menu'.
  -- The 'launch_menu' shows you the current processes / tabs running.
  config.launch_menu = props.launch_menu
  config.default_prog = props.default_prog
  config.window_background_opacity = props.window_background_opacity
  config.macos_window_background_blur = props.macos_window_background_blur
  config.font_size = props.font_size

  -- SECTION: STEP 3: Setting keybindings.
  -- INFO: 'Option' maps to 'ALT' on MAC.
  -- WARN: DISABLING DEFAULT KEYBINDINGS THAT ARE EITHER INCOMPATIBLE WITH WINDOWS, OR CAUSE I WANT TO CHANGE THEM.
  config.disable_default_key_bindings = props.disable_default_key_bindings
  config.keys = { -- TODO: Custom keybindings: (Self-explanatory)
    -- IMPORTANT: Avoid setting / overwritting 'CTRL+c' as it clashes with mutliple NeoVim plugins including 'neogit' & the 'snacks.nvim' terminal.
    {
      key = 'V',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.PasteFrom 'Clipboard', -- Paste from clipboard.
    },
    {
      key = 'C',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.CopyTo 'Clipboard', -- Copy from clipboard.
    },
    {
      key = 'F11',
      action = wezterm.action.ToggleFullScreen, -- Used to put the WezTerm instance into fullscreen mode.
    },
    {
      key = "L",
      --MAC
      mods = "CMD",
      --WINDOWS
      mods = "CTRL",
      action = wezterm.action.ShowDebugOverlay -- Used for checking Wezterm Debug output.
    },
    {
      key = "-",
      --MAC
      mods = "CMD",
      --WINDOWS
      mods = "CTRL",
      action = wezterm.action.DecreaseFontSize, -- Decrease Font Size.
    },
    {
      key = "=",
      --MAC
      mods = "CMD",
      --WINDOWS
      mods = "CTRL",
      action = wezterm.action.IncreaseFontSize, -- Increase Font Size.
    },
    {
      key = "t",
      --MAC
      mods = "CMD|ALT",
      --WINDOWS
      mods = "CTRL|ALT",
      action = wezterm.action.SpawnTab("DefaultDomain"), -- Create a new tab.
    },
    {
      key = "a",
      --MAC
      mods = "CMD",
      --WINDOWS
      mods = "ALT",
      action = wezterm.action.CloseCurrentTab({ confirm = true }), -- Close the current tab.
    },
    {
      --MAC
      key = "]",
      mods = "CMD|ALT",
      action = wezterm.action.ActivateTabRelative(1), -- Move to the right tab.
    },
    {
      key = "[",
      mods = "CMD|ALT",
      action = wezterm.action.ActivateTabRelative(-1), -- Move to the left tab.
      --WINDOWS
      mods = "CTRL|ALT",
      action = wezterm.action.ActivateTabRelative(-1), -- Move to the right tab.
    },
    {
      key = "[",
      mods = "CTRL|ALT",
      action = wezterm.action.ActivateTabRelative(1), -- Move to the left tab.
    },
    {
      key = "h",
      mods = "ALT",
      action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }), -- Split the window horizontally.
    },
    {
      key = "v",
      mods = "ALT",
      action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }), -- Split the window vertically.
    },
    {
      key = "h",
      --MAC
      mods = "CMD|ALT",
      --WINDOWS
      mods = "CTRL|ALT",
      action = wezterm.action.ActivatePaneDirection("Left") -- Move to the left Pane.
    },
    {
      key = "l",
      --MAC
      mods = "CMD|ALT",
      --WINDOWS
      mods = "CTRL|ALT",
      action = wezterm.action.ActivatePaneDirection("Right") -- Move to the right Pane.
    },
    {
      key = "j",
      --MAC
      mods = "CMD|ALT",
      --WINDOWS
      mods = "CTRL|ALT",
      action = wezterm.action.ActivatePaneDirection("Down") -- Move to the Pane below.
    },
    {
      key = "k",
      --MAC
      mods = "CMD|ALT",
      --WINDOWS
      mods = "CTRL|ALT",
      action = wezterm.action.ActivatePaneDirection("Up") -- Move to the Pane above.
    },
    {
      key = "i",
      --MAC
      mods = "CMD|ALT",
      --WINDOWS
      mods = "CTRL|ALT",
      action = wezterm.action.TogglePaneZoomState -- Temporarily set the pane to fill the entire window.
    },
    {
      key = "LeftArrow",
      --MAC
      mods = "CMD|ALT",
      --WINDOWS
      mods = "CTRL|ALT",
      action = wezterm.action.AdjustPaneSize({ "Left", 3 }) -- Adjust Pane to the Left.
    },
    {
      key = "RightArrow",
      --MAC
      mods = "CMD|ALT",
      --WINDOWS
      mods = "CTRL|ALT",
      action = wezterm.action.AdjustPaneSize({ "Right", 3 }) -- Adjust Pane to the Right.
    },
    {
      key = "DownArrow",
      --MAC
      mods = "CMD|ALT",
      --WINDOWS
      mods = "CTRL|ALT",
      action = wezterm.action.AdjustPaneSize({ "Down", 3 }) -- Adjust Pane Downward.
    },
    {
      key = "UpArrow",
      --MAC
      mods = "CMD|ALT",
      --WINDOWS
      mods = "CTRL|ALT",
      action = wezterm.action.AdjustPaneSize({ "Up", 4 }) -- Adjust Pane Upward.
    },
    {
      key = 'o',
      --MAC
      mods = 'CMD',
      --WINDOWS
      mods = 'ALT',
      action = wezterm.action_callback(function(window, _) -- Increase opacity
        local overrides = window:get_config_overrides() or {}
        local current_opacity = overrides.window_background_opacity or config.window_background_opacity
        overrides.window_background_opacity = math.min(1.0, current_opacity + 0.1)
        window:set_config_overrides(overrides)
      end),
    },
    {
      key = 'i',
      --MAC
      mods = 'CMD',
      --WINDOWS
      mods = 'ALT',
      action = wezterm.action_callback(function(window, _) -- Decrease opacity
        local overrides = window:get_config_overrides() or {}
        local current_opacity = overrides.window_background_opacity or config.window_background_opacity
        overrides.window_background_opacity = math.max(0.1, current_opacity - 0.1)
        window:set_config_overrides(overrides)
      end),
    },

      --MAC
    -- SECTION: macOS remappings for the CMD key. (Required when working on Mac)
    -- OOO: Keybind for saving using 'CMD':
    { key = "s", mods = "CMD",      action = wezterm.action.SendString("@s") },

    -- OOO: Navigation Signals to go between Neovim panes:
    -- (Refer to -> keymaps.lua 'Terminal Mode related mappings' SECTION)
    -- WARN: The below 'Signals' are specifically used when in the Neovim terminal window.
    -- REMEMBER: A 'pane' ONLY exists in Wezterm, NOT NeoVim, & a 'window' / 'buffer window'
    -- ONLY exists in Neovim, NOT Wezterm. You move between panes in wezterm,
    -- and windows in Neovim.
    -- NOTE: These 'Signals' are sent to Neovim, where it can interpret them as
    -- input for a keymap binding. (Refer to -> keymaps.lua)
    -- IMPORTANT: The 'mods' here must ONLY be 'CMD'. Using 'CMD|ALT' or 'CMD|CTRL' would
    -- clash with other the wezterm / neovim related key bindings.
    { key = "j", mods = "CMD",      action = wezterm.action.SendString("@j") },
    { key = "k", mods = "CMD",      action = wezterm.action.SendString("@k") },
    { key = "l", mods = "CMD",      action = wezterm.action.SendString("@l") },
    { key = "h", mods = "CMD",      action = wezterm.action.SendString("@h") },

    -- OOO: Terminal Window resizing signals to be sent to NeoVim keymappings.
    -- IMPORTANT: The 'mods' here must be 'CMD|CTRL', because using 'CMD|ALT' would
    -- clash with the wezterm key bindings to switch between wezterm panes.
    { key = "k", mods = "CMD|CTRL", action = wezterm.action.SendString("&k") },
    { key = "j", mods = "CMD|CTRL", action = wezterm.action.SendString("&j") },
  }
end

-- IMPORTANT: Finally, return the built configuration to WezTerm.
-- WARN: This is *NOT* accessible via Neovim as a Module. It's not included within Neovim's runtime.
return config
