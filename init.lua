-- Bootstraping lazy.nvim, LazyVim (Distro) and plugins.
require("config.options")
require("config.autocmds")
require("config.keymaps")
require("config.customcmds")
-- NOTE: Load lazy last after you have everything already setup.
require("config.lazy")

-- WARN: When Neovim starts up, 'init.lua' isn't the only configuration file that Neovim looks for.
-- Neovim actually looks for a bunch of additional configuration files in something called the "runtimepath".

-- IMPORTANT: "require" works out of the box here because 'lua' directories are searched for in the runtime path.

-- TODO:
-- This section initializes essential configurations for my Neovim setup,
-- enhancing productivity and workflow with LazyVim and various plugins.
--  XXX:
-- 'config.options' customizes Neovim settings for a better user experience.
-- 'config.autocmds' sets up automatic commands for improved functionality.
-- 'config.keymaps' defines custom keybindings for quick access to commands.
-- 'config.lazy' handles plugin management for efficient loading.
-- and linting support.
