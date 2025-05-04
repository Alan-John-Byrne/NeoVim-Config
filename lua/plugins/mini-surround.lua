return {
  "echasnovski/mini.surround",
  opts = {
    -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`:
    custom_surroundings = nil,
    -- Keymaps used:
    mappings = {              -- DEF::
      add = 'gsa',            -- Add surrounding
      find = 'gsf',           -- Find surrounding (to the right)
      find_left = 'gsF',      -- Find surrounding (to the left)
      highlight = 'gsh',      -- Highlight surrounding
      update_n_lines = 'gsn', -- Update `n_lines`
      replace = 'gsr',        -- Replace surrounding (Use 'gsr' and ignore "left or right of the cursor" options for 'under cursor' selection.)
      delete = 'gsd'          -- Delete surrounding (Use 'gsd'... *same as replace*)
    },
    -- Number of lines within which surrounding is searched:
    n_lines = 999999999
  },
}
