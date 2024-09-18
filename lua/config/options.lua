-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
-- Adding the PowerShell Profile Terminal Configuration:
vim.o.shell = "pwsh.exe"
-- NOTE: This is just pointing to the PowerShell 7 executable, made available through environment variables. It also include your own personal powershell 7 profile.

-- IMPORTANT: The options.lua file is used for setting Vim options, not for direct VIM API calls. Accessing the global vim lua table, and setting options. See full list of options using the ':options' command.

-- Turning on text wrap:
vim.opt.wrap = false -- Enable line wrapping
vim.opt.linebreak = true -- Avoid wrapping in the middle of words

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
