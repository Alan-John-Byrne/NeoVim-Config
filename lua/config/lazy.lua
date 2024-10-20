-- Setting up (Bootstrapping) Lazyvim Plugin Manager.

-- IMPORTANT: Accessing the 'stdpath' vimscript function, via the vim table (API), to use it in lua. THIS IS THE ONLY WAY TO USE VIMSCRIPT FUNCTIONS IN LUA PROGRAMS.
-- NOTE: The 'stdpath' is used for find stardard path used for our nvim config. See ':help stdpath' for details.
-- Lazy Plugin Manager is only interested in our nvim data directory / path. That being 'C:\Users\{yourusername}\Appdata\Local\nvim-data"
-- Neovim will remember things across sessions, because it can see the data in the below directory.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then -- Catching any errors on clone, then printing error.
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
-- Adding LazyVim path to the beginning of the runtime path table / array / list. Neovim comes here to get answers to questions it can't answer itself.
-- EG: For syntax highlight for particular types of files, if found, it will execute that file to get highlights.
-- This is how plugin loading works, we add our plugin and it's directory to the runtime path, and neovim will look for that plugin lua code,
-- when that plugin is loaded.
vim.opt.rtp:prepend(lazypath)

-- NOTE: Same as:
-- vim.opt.rtp.prepend(vim.opt.rtp, lazypath) where 'vim.opt.rtp' is actually the option / path we are appending another path onto.

-- IMPORTANT: We add lazypath to the beginning of the runtime path, so when neovim needs to ask a question, it's always going to ask Lazy first.

-- 'require' looks for a directory called "lazy", and if there is an 'init.lua' file then actually run
-- that init.lua file, because it's the lazy plugin manager's (which is a plugin in and of itself).

require("lazy").setup({
  spec = {
    -- Add LazyVim and Import its plugins.
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- NOTE: Import/override with your base plugins.
    { import = "plugins.new" },
    { import = "plugins.altered" },
    { import = "plugins.disabled" }, -- NOTE: This is a table of plugins that I've disabled that are installed by default by the LazyVim distro.
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
