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

-- NOTE: Format on buffer content save.
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",                          -- This applies to all files, you can change the pattern to a specific file type (e.g. "*.lua")
  callback = function()
    vim.lsp.buf.format({ async = false }) -- This Triggers the formatting.
  end,
})

-- NOTE: Opening the 'bufferline' plugin only if NOT displaying
-- certain kinds of buffers. This is being determined by the buffer's different available options.
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  callback = function()
    if vim.bo.filetype ~= "snacks_dashboard" and vim.bo.filetype ~= "minifiles" and vim.bo.buftype ~= "nofile" then
      local ok_bufferline, bufferline = pcall(require, "bufferline")
      if ok_bufferline then
        vim.opt.showtabline = 2
      end
    end
  end,
})
-- WARN: We can do the above with the 'bufferline' plugin because it has no settings that
-- this autocommand will clash with. So, the plugin doesn't already provided
-- a way to hide tabs until off either the dashboard, or other buffers of a certain kind.
