local wezterm = require('wezterm') -- NOTE: Pull in the WezTerm API.
local config = wezterm.config_builder()
local win_keys = {                 -- TODO: Custom keybindings: (Self-explanatory)
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
    mods = "ALT",
    action = wezterm.action.CloseCurrentTab({ confirm = true }), -- Close the current tab.
  },
  {
    key = "]",
    mods = "CTRL|ALT",
    action = wezterm.action.ActivateTabRelative(1), -- Move to the left tab.
  },
  {
    key = "[",
    mods = "CTRL|ALT",
    action = wezterm.action.ActivateTabRelative(-1), -- Move to the right tab.
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
  {
    key = 'o',
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
    mods = 'ALT',
    action = wezterm.action_callback(function(window, _) -- Decrease opacity
      local overrides = window:get_config_overrides() or {}
      local current_opacity = overrides.window_background_opacity or config.window_background_opacity
      overrides.window_background_opacity = math.max(0.1, current_opacity - 0.1)
      window:set_config_overrides(overrides)
    end),
  },
}

return win_keys
