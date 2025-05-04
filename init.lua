-- TODO: This section initializes essential configurations for the Neovim setup,
-- enhancing the workflow for productivity with various plugins.
require("config.options")    -- Customizes Neovim settings for a better user experience.
require("config.autocmds")   -- Sets up automatic commands for improved functionality.
require("config.keymaps")    -- Defines custom keybindings for quick access to commands.
require("config.customcmds") -- Defines custom convenience commands for the user to use.
-- NOTE: Load lazy last after you have everything already setup.
require("config.lazy")       -- Bootstraping the lazy.nvim plugin manager.

-- WARN: When Neovim starts up, "init.lua" isn't the only configuration
-- file that Neovim looks for. Neovim actually looks for a bunch of additional
-- configuration files in something called the "runtimepath" (vim.o.rtp).
-- REMEMBER: Neovim's "require" mechanism looks through several kinds of subdirectories
-- within each path included within the "runtimepath". It will look through the following
-- child directories:
-- 1. lua: Primary directory where your Lua modules should reside.
--IMPORTANT: (Not necessary if using the lazy.nvim package manager.)
-- 2. after: For Lua files that should be sourced after all other lua files in the "runtimepath".
-- We override with 'opts' in lazy.nvim, so it's redundant with lazy.nvim.
-- 3. pack: Another method for managing plugins, often used when managing plugins without a package manager like lazy.nvim.
