return {
  "echasnovski/mini.surround",
  opts = {
    -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`:
    custom_surroundings = nil,
    -- Keymaps used:
    mappings = {              -- DEF::
      add = "gsa",            -- Add surrounding
      delete = "gsd",         -- Delete surrounding
      find = "gsf",           -- Find surrounding (to the right)
      find_left = "gsF",      -- Find surrounding (to the left)
      highlight = "gsh",      -- Highlight surrounding
      update_n_lines = "gsn", -- Update `n_lines`

      -- IMPORTANT: replace = "gsr" Overwriting 'gsr' keymap in custom configuration. (Removing unecessary extra 'replace' keybindings)
    },
    -- Number of lines within which surrounding is searched:
    n_lines = 999999999
  },
  config = function(_, opts)
    local miniSurround = require("mini.surround")
    -- Setting up using current options:
    miniSurround.setup(opts)

    -- NOTE: Custom keybind replace original 'replace' keymap.
    vim.keymap.set("n", "gsr", function() miniSurround.replace() end);
  end
}
