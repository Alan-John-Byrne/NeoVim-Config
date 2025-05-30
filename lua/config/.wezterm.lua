-- NOTE: Open the Debug menu using 'CTRL+SHIFT L'.
-- WARN: Pull in the WezTerm API.
local wezterm = require('wezterm')

-- IMPORTANT: Configuration Location: (MUST BE SET WITHIN GLOBAL SYSTEM ENVIRONMENT VARIABLES, NOT A PROFILE)

-- TODO: Instantiating the configuration builder.
-- (This is our wezterm configuration settings.)
-- NOTE: Refer to the configuration options here -> https://wezterm.org/config/keys.html,
-- and the Lua Reference (API) here -> https://wezterm.org/config/lua/general.html.
local config = wezterm.config_builder()

-- XXX: This is where you actually apply your config preferences:
-- NOTE: Right click any tab in the top bar to display the 'launch_menu'. The 'launch_menu' shows you the current processes / tabs running.
config.launch_menu = {
  { -- Runs the 'top' program to monitor process activity.
    args = { 'top' }
  },
  {                              -- Launches Powershell.
    label = 'Powershell',        -- The name of the program.
    args = { 'pwsh', '-NoLogo' } -- Command used to launch the program.
  }
  -- (I use PowerShell... I know... lol... leave me alone... SHHHHHHH!!! GO AWAY!!!)
}

config.adjust_window_size_when_changing_font_size = false -- Don't change the size of the window when adjusting the font size.
config.color_scheme = 'Gruvbox Dark (Gogh)'               -- Changing the colourscheme.
config.default_prog = { 'pwsh' }                          -- 'pwsh' / PowerShell 7 must be available within the global environmental variables, not powershell profile.
config.enable_scroll_bar = true                           -- Enabling the scrollbar.
config.font = wezterm.font_with_fallback({                -- Setting proper font families to fall back on if certain icons aren't available in some.
  { family = 'JetBrainsMono NFP',          weight = 'Light', italic = false, scale = 1 },
  { family = 'JetBrainsMono NF',           weight = 'Light', italic = false, scale = 1 },
  { family = 'Noto Sans Linear B Regular', weight = 'Light', italic = false, scale = 1 },
})
config.window_background_opacity = 1    -- Adjust between 0.0 and 1.0
config.macos_window_background_blur = 0 -- Adjust blur radius (20-50 is typical)
config.font_size = 12

-- Setting keybindings.
config.disable_default_key_bindings = true -- WARN: DISABLING DEFAULT KEYBINDINGS THAT ARE EITHER INCOMPATIBLE WITH WINDOWS, OR CAUSE I WANT TO CHANGE THEM.
config.keys = {                            -- TODO: Custom keybindings: (Self-explanatory)
  -- IMPORTANT: Avoid setting / overwritting 'CTRL+c' as it clashes with mutliple NeoVim plugins including 'neogit' & the 'snacks.nvim' terminal.
  {
    key = 'V',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.PasteFrom 'Clipboard', -- Copy from clipboard.
  },
  {
    key = 'C',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CopyTo 'Clipboard', -- Paste from clipboard.
  },
  {
    key = 'F11',
    action = wezterm.action.ToggleFullScreen, -- Used to put the WezTerm instance into fullscreen mode.
  },
  {
    key = "L",
    mods = "CTRL",
    action = wezterm.action.ShowDebugOverlay -- Used for checking Wezterm Debug output.
  },
  {
    key = "-",
    mods = "CTRL",
    action = wezterm.action.DecreaseFontSize, -- Decrease Font Size.
  },
  {
    key = "=",
    mods = "CTRL",
    action = wezterm.action.IncreaseFontSize, -- Increase Font Size.
  },
  {
    key = "t",
    mods = "CTRL|ALT",
    action = wezterm.action.SpawnTab("DefaultDomain"), -- Create a new tab.
  },
  {
    key = "a",
    mods = "CTRL",
    action = wezterm.action.CloseCurrentTab({ confirm = true }), -- Close the current tab.
  },
  {
    key = "]",
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
    mods = "CTRL|ALT",
    action = wezterm.action.ActivatePaneDirection("Left") -- Move to the left Pane.
  },
  {
    key = "l",
    mods = "CTRL|ALT",
    action = wezterm.action.ActivatePaneDirection("Right") -- Move to the right Pane.
  },
  {
    key = "j",
    mods = "CTRL|ALT",
    action = wezterm.action.ActivatePaneDirection("Down") -- Move to the Pane below.
  },
  {
    key = "k",
    mods = "CTRL|ALT",
    action = wezterm.action.ActivatePaneDirection("Up") -- Move to the Pane above.
  },
  {
    key = "i",
    mods = "CTRL|ALT",
    action = wezterm.action.TogglePaneZoomState -- Temporarily set the pane to fill the entire window.
  },
  {
    key = "LeftArrow",
    mods = "CTRL|ALT",
    action = wezterm.action.AdjustPaneSize({ "Left", 3 }) -- Adjust Pane to the Left.
  },
  {
    key = "RightArrow",
    mods = "CTRL|ALT",
    action = wezterm.action.AdjustPaneSize({ "Right", 3 }) -- Adjust Pane to the Right.
  },
  {
    key = "DownArrow",
    mods = "CTRL|ALT",
    action = wezterm.action.AdjustPaneSize({ "Down", 3 }) -- Adjust Pane Downward.
  },
  {
    key = "UpArrow",
    mods = "CTRL|ALT",
    action = wezterm.action.AdjustPaneSize({ "Up", 4 }) -- Adjust Pane Upward.
  },
}

-- IMPORTANT: Finally, return the built configuration to WezTerm.
-- INFO: This is not accessible via Neovim as a Module. It's not included within it's runtime.
return config
