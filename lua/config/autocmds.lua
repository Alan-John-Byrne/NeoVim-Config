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

-- If the current buffer is a terminal buffer, enter insert mode automatically.
vim.api.nvim_create_autocmd({ "TermOpen", "WinEnter" }, {
  callback = function()
    local buffer_name = vim.api.nvim_buf_get_name(0)
    if buffer_name:match("term") or buffer_name:match("Powershell") then
      vim.api.nvim_buf_set_name(0, "Powershell.exe")
      vim.cmd("startinsert")
    end
  end,
})
