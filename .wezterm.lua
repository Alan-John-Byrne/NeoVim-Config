-- NOTE: Open the Debug menu using 'CTRL+SHIFT L'.
-- WARN: Pull in the wezterm API.
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

config.color_scheme = 'Gruvbox Dark (Gogh)' -- Changing the colourscheme.
config.default_prog = { 'pwsh' }            -- 'pwsh' / PowerShell 7 must be available within the global environmental variables, not powershell profile.
config.enable_scroll_bar = true             -- Enabling the scrollbar.
config.font = wezterm.font_with_fallback({  -- Setting proper font families to fall back on if certain icons aren't available in some.
  { family = 'JetBrainsMono NF',           weight = 'Light', italic = false, scale = 1 },
  { family = 'JetBrainsMono NFP',          weight = 'Light', italic = false, scale = 1 },
  { family = 'Noto Sans Linear B Regular', weight = 'Light', italic = false, scale = 1 }
})

-- Setting keybindings.
config.disable_default_key_bindings = true -- WARN: DISABLING DEFAULT KEYBINDINGS THAT ARE EITHER INCOMPATIBLE WITH WINDOWS, OR CAUSE I WANT TO CHANGE THEM.
config.keys = {                            -- TODO: Custom keybindings: (Self-explanatory)
  {
    key = "c",
    mods = "CTRL",
    action = wezterm.action.CopyTo("Clipboard"), -- Copy to the clipboard.
  },
  {
    key = "v",
    mods = "CTRL",
    action = wezterm.action.PasteFrom("Clipboard"), -- Paste from the clipboard.
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
    action = wezterm.action.AdjustPaneSize({ "Up", 3 }) -- Adjust Pane Upward.
  },
}

-- IMPORTANT: Finally, return the built configuration to wezterm.
return config
