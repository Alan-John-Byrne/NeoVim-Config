-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- IMPORTANT: This file is for setting up autocommands in LazyVim.
-- Autocommands are used to automatically execute code in response to specific events.

-- WARN: This autocmds.lua file is used for direct VIM API calls.

-- NOTE: The 'ColorScheme' event is triggered whenever the colorscheme of neovim changes.

vim.api.nvim_create_autocmd("ColorScheme", { -- Changing the line number colorscheme.
  callback = function()
    vim.defer_fn(function()
      vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "grey" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "white" })
      vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "grey" })
    end, 100)
  end,
})
