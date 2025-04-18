return {
  "echasnovski/mini.surround",
  opts = {
    -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`:
    custom_surroundings = nil,
    -- Keymaps used:
    mappings = {              -- DEF::
      add = "gsa",            -- Add surrounding
      find = "gsf",           -- Find surrounding (to the right)
      find_left = "gsF",      -- Find surrounding (to the left)
      highlight = "gsh",      -- Highlight surrounding
      update_n_lines = "gsn", -- Update `n_lines`

      -- IMPORTANT: - Overwriting keymaps. (Removing unecessary / 'extra' keybindings)
      -- replace = "gsr" - Replace surrounding
      -- delete = "gsd" - Delete surrounding
    },
    -- Number of lines within which surrounding is searched:
    n_lines = 999999999
  },
  config = function(_, opts)
    local miniSurround = require("mini.surround")
    -- Setting up using current options:
    miniSurround.setup(opts)

    -- NOTE: Custom keybinds to replace original keymaps Overwritten above.
    vim.keymap.set("n", "gsr", function() miniSurround.replace() end);
    vim.keymap.set("n", "gsd", function() miniSurround.delete() end);
  end
}
