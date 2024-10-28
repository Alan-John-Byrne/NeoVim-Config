-- PLUGIN: Installing the 'mini.files' plugin. It serves as an alternative directory navigation tool to NeoTree and others.
return {
  "echasnovski/mini.files",
  enabled = true, -- TESTING
  keys = {
    {
      "<leader>e",
      "<cmd>lua MiniFiles.open()<CR>",
      desc = "Open Neogit status popup",
      { noremap = true, silent = true },
    },
  },
  -- IMPORTANT: Below are the default configuration for the mini.files plugin, for illustrative purposes. No overwriting is happening here.
  opts = {
    -- NOTE: Customization of explorer windows
    windows = {
      -- Maximum number of windows to show side by side
      max_number = math.huge,
      -- Whether to show preview of file/directory under cursor
      preview = true,
      -- Width of focused window
      width_focus = 25,
      -- Width of non-focused window
      width_nofocus = 15,
      -- Width of preview window
      width_preview = 50,

      -- NOTE: Customization of explorer windows
      mappings = {
        close = "q", -- Closes the explorer
        go_in = "l", -- Goes into the next directory / file
        go_in_plus = "L", -- Goes into the file currently under the cursor
        go_out = "h", -- Goes back out of the directory, into the previous directory.
        go_out_plus = "H", -- Goes back out of the directory, into the previous directory, closing any previews open at the time.
        synchronize = "=", -- Confirm changes, as in added files or directories.
        trim_left = "<", -- Remove previews from the right of the current directory.
        trim_right = ">", -- Remove previews from the left of the current directory.
        show_help = "g?", -- Get help.
      },
    },
  },
}
