-- PLUGIN: The 'mini.files' plugin provides an alternative directory navigation tool to NeoTree and others.
return {
  "echasnovski/mini.files",
  enabled = true, -- TESTING
  keys = {
    {
      "<leader>e",
      "<cmd>lua MiniFiles.open()<CR>",
      desc = "Open File Explorer",
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
        close = "q",       -- Closes the explorer
        go_in = "l",       -- Goes into the next directory / file
        go_in_plus = "L",  -- Goes into the file currently under the cursor
        go_out = "h",      -- Goes back out of the directory, into the previous directory.
        go_out_plus = "H", -- Goes back out of the directory, into the previous directory, closing any previews open at the time.
        synchronize = "=", -- Confirm changes, as in added files or directories.
        trim_left = "<",   -- Remove previews from the right of the current directory.
        trim_right = ">",  -- Remove previews from the left of the current directory.
        show_help = "g?",  -- Get help.
        image_preview = "<leader>p"
      },
    },
  },
  config = function(_, opts)
    -- NOTE: Setting up mini.files
    local mini_files = require("mini.files")
    mini_files.setup(opts)

    -- WARN: Function for previewing images within a split pane when using 'WezTerm'.
    local function preview_image()
      -- First Check if we are in minifiles:
      if vim.bo.filetype ~= "minifiles" then
        print("You aren't exploring in MiniFiles")
        return
      end
      -- Get the file (entrypoint) below the cursor.
      local entry = mini_files.get_fs_entry()
      -- If the entrypoint / file doesn't exist, stop!
      if not entry or entry.fs_type ~= "file" then
        return
      end
      -- If the user is correctly using the Wezterm terminal, go ahead.
      if os.getenv("WEZTERM_PANE") ~= nil then
        -- If the file does exist, get it's absolute path.
        local path = entry.path
        -- Check for matching image cases:
        if path:match("%.png$")
            or path:match("%.jpg$")
            or path:match("%.jpeg$")
            or path:match("%.gif$") then
          -- XXX: Open Preview Pane. (Requires PowerShell7 in Global Env Variables
          -- & WezTerm in PowerShell7 Profile Env Variables)
          command = "silent !wezterm cli split-pane -- pwsh -Command " ..
              "\"wezterm imgcat '" .. path .. "'; Read-Host 'Press Enter to continue'\""
          vim.api.nvim_command(command)
        else
          print("Not an Image file.")
        end
        -- If not using Wezterm, sorry lol!
      else
        print("You MUST use 'Wezterm', to preview images!")
        return
      end
    end

    -- IMPORTANT: Keymap
    vim.keymap.set("n", "<leader>p", preview_image, { desc = "Preview Image" })
  end
}
