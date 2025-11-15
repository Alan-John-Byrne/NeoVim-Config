--  PLUGIN: The 'vim-visual-multi' plugin allows easy use of multiple cursors.
return {
  "mg979/vim-visual-multi", -- Originally a 'vim' plugin.
  enabled = true,
  branch = "master",
  event = "VeryLazy",
  init = function()
    -- NOTE: Clearing current mappings:
    vim.g.VM_default_mappings = 0

    -- IMPORTANT: Setting compatible mappings:
    vim.g.VM_maps = {
      -- INFO: Using 'Alt' instead of 'CTRL', more compatible.
      ["Switch Mode"] = "<Tab>",
      ["Find Under"] = "<A-d>",
      ["Find Subword Under"] = "<A-d>",
      ["Add Cursor At Pos"] = "<A-n>",
      ["Add Cursor Down"] = "<A-Down>",
      ["Add Cursor Up"] = "<A-Up>",
      -- WARN: Disabling permanent mappings:
      --(*They clash with other functionality / plugins*)
      ["Select Cursor Down"] = "", -- Disable
      ["Select Cursor Up"] = ""    -- Disable
    }
    -- REMEMBER: Most mappings provided by this plugin are not being used because
    -- the same functionality is provided by other plugins or neovim features.
  end
}
