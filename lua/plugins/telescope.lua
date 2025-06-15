-- WARN: MUST HAVE 'fzf' BINARY INSTALLED VIA BREW FOR THIS SET / TABLE OF PLUGINS TO WORK.
return {
  -- PLUGIN: The 'telescope-fzf-native' plugin is a Telescope extension that uses fzf's native C sorting algorithm to make Telescope faster.
  {
    -- INFO: 'fzf' is a fast, terminal-based fuzzy finder written in Go, usable both in and outside Neovim.
    'nvim-telescope/telescope-fzf-native.nvim', -- Telescope extension that uses fzf's native algorithm for faster sorting
    build = 'mingw32-make',
    cond = vim.fn.executable("mingw32-make.exe") ==
        1 -- NOTE: Ensures 'make' is available to build the native C extension
  },
  -- PLUGIN: The 'telescope.nvim' plugin, is a Lua-based fuzzy finder plugin built for Neovim, offering an extensible, UI-rich experience.
  {
    'nvim-telescope/telescope.nvim',
    priority = 10000,
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope_plugin = require("telescope")
      telescope_plugin.setup({
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          }
        }
      })
      -- To get fzf loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      telescope_plugin.load_extension("fzf")
    end
  }
}

-- NOTE:
-- 'fzf' is the core fuzzy finder engine (Go-based), 'fzf.vim' is a Vim plugin that wraps it,
-- 'telescope.nvim' is a native Lua fuzzy finder for Neovim, and 'telescope-fzf-native.nvim' lets
-- Telescope use fzf’s C-based sorting for speed, without relying on fzf's UI.
