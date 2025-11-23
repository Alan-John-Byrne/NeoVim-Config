local wezterm = require('wezterm') -- NOTE: Pull in the WezTerm API.
local config = wezterm.config_builder()
local mac_keys = {                 -- TODO: Custom keybindings: (Self-explanatory)
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
    mods = "CMD",
    action = wezterm.action.ShowDebugOverlay -- Used for checking Wezterm Debug output.
  },
  {
    key = "-",
    mods = "CMD",
    action = wezterm.action.DecreaseFontSize, -- Decrease Font Size.
  },
  {
    key = "=",
    mods = "CMD",
    action = wezterm.action.IncreaseFontSize, -- Increase Font Size.
  },
  {
    key = "t",
    mods = "CMD|ALT",
    action = wezterm.action.SpawnTab("DefaultDomain"), -- Create a new tab.
  },
  {
    key = "a",
    mods = "CMD",
    action = wezterm.action.CloseCurrentTab({ confirm = true }), -- Close the current tab.
  },
  {
    key = "]",
    mods = "CMD|ALT",
    action = wezterm.action.ActivateTabRelative(1), -- Move to the right tab.
  },
  {
    key = "[",
    mods = "CMD|ALT",
    action = wezterm.action.ActivateTabRelative(-1), -- Move to the left tab.
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
    mods = "CMD|ALT",
    action = wezterm.action.ActivatePaneDirection("Left") -- Move to the left Pane.
  },
  {
    key = "l",
    mods = "CMD|ALT",
    action = wezterm.action.ActivatePaneDirection("Right") -- Move to the right Pane.
  },
  {
    key = "j",
    mods = "CMD|ALT",
    action = wezterm.action.ActivatePaneDirection("Down") -- Move to the Pane below.
  },
  {
    key = "k",
    mods = "CMD|ALT",
    action = wezterm.action.ActivatePaneDirection("Up") -- Move to the Pane above.
  },
  {
    key = "i",
    mods = "CMD|ALT",
    action = wezterm.action.TogglePaneZoomState -- Temporarily set the pane to fill the entire window.
  },
  {
    key = "LeftArrow",
    mods = "CMD|ALT",
    action = wezterm.action.AdjustPaneSize({ "Left", 3 }) -- Adjust Pane to the Left.
  },
  {
    key = "RightArrow",
    mods = "CMD|ALT",
    action = wezterm.action.AdjustPaneSize({ "Right", 3 }) -- Adjust Pane to the Right.
  },
  {
    key = "DownArrow",
    mods = "CMD|ALT",
    action = wezterm.action.AdjustPaneSize({ "Down", 3 }) -- Adjust Pane Downward.
  },
  {
    key = "UpArrow",
    mods = "CMD|ALT",
    action = wezterm.action.AdjustPaneSize({ "Up", 4 }) -- Adjust Pane Upward.
  },
  {
    key = 'o',
    mods = 'CMD',
    action = wezterm.action_callback(function(window, _) -- Increase opacity
      local overrides = window:get_config_overrides() or {}
      local current_opacity = overrides.window_background_opacity or config.window_background_opacity
      overrides.window_background_opacity = math.min(1.0, current_opacity + 0.1)
      window:set_config_overrides(overrides)
    end),
  },
  {
    key = 'i',
    mods = 'CMD',
    action = wezterm.action_callback(function(window, _) -- Decrease opacity
      local overrides = window:get_config_overrides() or {}
      local current_opacity = overrides.window_background_opacity or config.window_background_opacity
      overrides.window_background_opacity = math.max(0.1, current_opacity - 0.1)
      window:set_config_overrides(overrides)
    end),
  },

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

return mac_keys
