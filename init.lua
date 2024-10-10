-- Setting up custom functions module. NOTE: Required for adding the modules to the packages path so they can be used from anywhere.
require("custom.my_functions")

-- Bootstraping lazy.nvim, LazyVim and plugins
require("config.lazy")
require("config.autocmds")
require("config.options")
require("config.keymaps")
require("config.dapconfigs")
require("config.lspconfigs")

-- IMPORTANT: "require" already works here because 'lua' directories are searched for in the runtime path.

-- TODO:
-- This section initializes essential configurations for my Neovim setup,
-- enhancing productivity and workflow with LazyVim and various plugins.
--
-- 'config.lazy' handles plugin management for efficient loading.
-- 'config.autocmds' sets up automatic commands for improved functionality.
-- 'config.options' customizes Neovim settings for a better user experience.
-- 'config.keymaps' defines custom keybindings for quick access to commands.
-- 'config.dapconfigs' configures debugging settings to streamline development.
-- 'config.lspconfigs' sets up Language Server Protocol settings for code completion
-- and linting support.
--
-- 'custom.my_functions' contains my custom functions for added functionality
-- tailored to my workflow.
