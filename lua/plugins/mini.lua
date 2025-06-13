return {
  -- PLUGIN: The 'mini.files' plugin provides an alternative directory navigation tool to NeoTree and others.
  {
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
    -- IMPORTANT: Below are the default configuration for the mini.files plugin.
    -- For illustrative purposes. Omitting this would make no changes.
    opts = {
      -- NOTE: Customization of explorer windows
      options = {
        show_dotfiles = true
      },
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
            -- OOO: Open preview pane using external 'WezTerm' commands.
            -- INFO: Running command as a raw sub-process. 'vim.fn.jobstart' needed for precise control over external commands.
            -- NOTE: Array of arguments avoids 'string quote issues' entirely.
            vim.fn.jobstart(
              {                                                                      -- OOO: Every item passed in the array / table here is considered an actual argument:
                "wezterm", "cli", "split-pane", "--percent", "90", "--",             -- '--' means everything after is not a flag / option.
                "bash", "-c",                                                        -- Invoke a new login interave bash shell.
                "wezterm imgcat '" .. path .. "'; read -p 'Press Enter to continue'" -- Run the wezterm command.
              }, { detach = true })                                                  -- 'detach' tells neovim not to wait for output or block the interface. Just to run the command and forget about it.
            -- IMPORTANT: Bad Method:
            -- local command = "silent !wezterm cli split-pane --percent 90 -- bash -c '" ..
            --     "wezterm imgcat " .. path .. "; read -p \"Press Enter to continue\"'"
            -- vim.api.nvim_command(command)
            -- OOO: NEVER USE 'vim.api.nvim_command' OR 'vim.cmd'. These are treated as vimscript.
            -- They're not
            -- > Quote safe - Gets confused between `'` & `"`.
            -- > Shell safe - Don't communicate effectively with the external shell environment.
            -- WARN: This command string above is parsed in this order:
            -- 1. First by lua
            -- 2. Then by vim's command handler
            -- 3. Then by the external shell, i.e. bash.
            -- 4. Then again by 'bash -c'.
            -- So things fall apart quickly.
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
  },
  -- PLUGIN: The 'mini.icons' plugin provides better icons within directory navigation tools like 'mini.files'.
  {
    "echasnovski/mini.icons",
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  -- PLUGIN: The 'mini.surround' plugin provides a way to conveniently add surroundings to selected portions of text / code.
  {
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
}
