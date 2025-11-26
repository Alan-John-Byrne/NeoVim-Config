-- INFO: These lines extend NeoVim's Lua runtime path (rtp = `package.path` and `package.cpath`) to include the LuaRocks tree located at:
-- > macOS: `~/.config/nvim/lua/luarock-modules`
-- > Windows: `%USERPROFILE%\AppData\Local\nvim\lua\luarock-modules`
-- Yes, we located this directory within Neovim's configuration file structure. This directory now serves as the
-- default location ('tree root') that plugins will be installed to. The 'tree root' being configured via:
-- > macOS: `~/.config/luarocks/config.lua`
-- > Windows: `%USERPROFILE%\AppData\Roaming\luarocks\config.lua`
-- Lua packages are installed here using the `--tree` parameter. This allows Neovim to locate and load Lua modules
-- (packages / libraries) installed via the 'LuaRocks' package manager.
-- NOTE: This shared directory can also be added to other Lua environments (like WezTerm - which it has
-- been added to) so that both programs can reuse the same Lua packages installed via LuaRocks.
-- IMPORTANT: These lines must be evaluated *before* any `require` statements for external Lua modules.
-- SECTION: STEP 0: NeoVim Specific Runtime Environment Setup.
-- When Neovim starts up, "init.lua" isn't the only configuration
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
-- TODO: Extend WezTerm's Lua runtime path (rtp = `package.path` [ and also `package.cpath` in the case of using macOS ]) to include...
-- the LuaRocks-managed `luarock-modules` directory used by Neovim (also included within Neovims own rtp).
-- This directory is now the default location (tree root) that plugins will be installed to (configured via
-- `~/.config/luarocks/config.lua`) via the 'luarocks' package manager. Lua packages are installed here using
-- the `--tree`. So, instead of WezTerms own configuration. It's like Neovim sharing lua packages it uses, with
-- WezTerm. This is where WezTerm will load external libraries from. Therefore, both programs read from the same
-- place for external custom lua packages, during their own runtimes.
if io.open(os.getenv("HOME") .. "/.config/nvim/lua/config/wezterm_config/wezterm_utility.lua", "r") then
  -- OOO: macOS:
  local home = os.getenv("HOME")
  local luarocks_modules = home .. "/.config/nvim/lua/luarock-modules"
  -- STEP: 1: Adding luarocks 'Lua' modules.
  package.path = package.path ..
      ";" ..
      luarocks_modules .. "/share/lua/5.4/?.lua" .. ";" .. luarocks_modules .. "/share/lua/5.4/?/init.lua"
  -- STEP: 2: Adding luarocks 'C' modules.
  package.cpath = package.cpath .. ";" .. luarocks_modules .. "/lib/lua/5.4/?.so"
elseif io.open(os.getenv("USERPROFILE") .. "/AppData/Local/nvim/lua/config/wezterm_config/wezterm_utility.lua", "r") then
  -- OOO: Windows:
  local user_profile = os.getenv("USERPROFILE")
  local luarocks_modules = user_profile .. "/AppData/Local/nvim/lua/luarock-modules"
  -- STEP: 1: Adding luarocks 'Lua' modules.
  package.path = package.path ..
      ";" ..
      luarocks_modules .. "/share/lua/5.1/?.lua" .. ";" .. luarocks_modules .. "/share/lua/5.1/?/?.lua"
  -- NOTE: Windows does not require 'C' modules.
end
-- IMPORTANT: The above steps *MUST* lines must be evaluated *BEFORE* any `require` statements for external Lua modules.
-- REMEMBER: The '.wezterm.lua' config file is a static lua script loaded only by the WezTerm program's
-- process during startup (or reloaded on a manual config reload). It is *NOT* a module and
-- cannot be 'required' by other programs like Neovim. The WezTerm and Neovim applications run
-- as their own completely separate processes and do not share memory or state — there is no
-- Inter-Process Communication (IPC). Therefore, changes to WezTerm must be done in its own
-- environment and reloaded explicitly.
-- WARN: Any nvim configuration modules (lua modules that you've written within your nvim config)
-- containing any 'vim' related module calls, will result in errors. As stated, WezTerm & NeoVim don't share the same runtime.

-- SECTION: STEP 1: Loading essential NeoVim configuration files.
-- TODO: This section initializes essential configurations for the Neovim setup,
-- enhancing the workflow for productivity with various plugins.

-- ERROR: Avoid this:
-- require("config.custom_nvim_lua_libraries.cross_os")
-- require("config.custom_nvim_lua_libraries.vim_utility")
-- Because, each lua file has it's own environment. So, including custom libraries here within the base init.lua
-- file, doesn't mean your modules will be made available to modules required after.
-- EXAMPLE: e.g.: require("config.options") comes after these imports, it *DOES NOT* mean that options.lua
-- suddenly has access to content (i.e.: methods / variables ) of either of these modules.

require("config.options")    -- Customizes Neovim settings for a better user experience.
require("config.autocmds")   -- Sets up automatic commands for improved functionality.
require("config.keymaps")    -- Defines custom keybindings for quick access to commands.
require("config.customcmds") -- Defines custom convenience commands for the user to use.
-- NOTE: Load lazy last after you have everything already setup.
require("config.lazy")       -- Bootstraping the lazy.nvim plugin manager.
