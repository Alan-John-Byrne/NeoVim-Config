-- INFO: These lines extend NeoVim's Lua runtime path (rtp = `package.path` and `package.cpath`) to include
-- the LuaRocks tree located at `~/.config/nvim/lua/luarock-modules` directory (yes, we located this within
-- Neovim's configuration file structure). This directory is now the default location (tree root) that plugins
-- will be installed to (configured via `~/.config/luarocks/config.lua`) via the 'luarocks' package manager.
-- Lua packages are installed here using the `--tree` parameter. This allows Neovim to locate and load Lua modules
-- (packages / libraries) installed via the LuaRocks package manager.
-- NOTE: This shared directory can also be added to other Lua environments (like WezTerm - which it has
-- been added to) so that both programs can reuse the same Lua packages installed via LuaRocks.
-- IMPORTANT: These lines must be evaluated *before* any `require` statements for external Lua modules.
local lua_rocks_nvim_wezterm_path = os.getenv("HOME") .. "/.config/nvim/lua/luarock-modules"
package.path = package.path ..
    ";" ..
    lua_rocks_nvim_wezterm_path .. "/share/lua/5.4/?.lua;" .. lua_rocks_nvim_wezterm_path .. "/share/lua/5.4/?/init.lua"
package.cpath = package.cpath .. ";" .. lua_rocks_nvim_wezterm_path .. "/lib/lua/5.4/?.so"
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
