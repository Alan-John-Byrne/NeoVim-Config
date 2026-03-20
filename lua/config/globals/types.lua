-- NOTE: The Lua-language-server ('lua LSP') doesn't execute the lua code within this
-- configuration — it does static analysis. It doesn't follow the fact that init.lua
-- ran "vim.utility = require(...)" and infer that "vim.utility" is now a module of
-- type / classVimUtility in every other file. Each file is analyzed mostly in isolation,
-- so when "lua/config/keymaps.lua" references vim.utility, the LSP doesn't know what that is.
-- So...

-- FIX: We must tell the 'lua LSP' about these modules explicitly.
-- In a file that lua-language-server picks up globally (like a
-- types file or at the top of your module), we add:

-- INFO: The '---@meta' Lua-Cats tag tells the 'lua LSP' that this
-- file is for type information only and shouldn't be treated as runtime code.

---@meta

---@type VimUtility
vim.utility = vim.utility

---@type VimConfigUtility
vim.config_utility = vim.config_utility

---@type CrossOS
vim.cross_os = vim.cross_os
