-- PLUGIN: The 'neogit.nvim' plugin provides a better git project
-- management expierence.
return {
  "NeogitOrg/neogit",
  enabled = true,     -- TESTING
  event = "VeryLazy", -- NOTE: 'VeryLazy' only loads the plugin when needed (On powershell files).
  -- IMPORTANT: 'VeryLazy' allows package managers (e.g.: lazy.nvim, Mason, etc...) to load the plugin ahead of time,
  -- so we can request them later within another plugins config functions. Otherwise we get errors saying a plugin 'doesn't
  -- exist', cause we create a race condition saying we need it to load the plugin before even it's package manager has a chance to load.
  priority = 1,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "ibhagwan/fzf-lua",
  },
  keys = function()
    local neogit = require("neogit")
    return { -- REMEMBER: You have to use functions here to prevent methods from being called on entering neovim.
      { '<leader>gC', function() neogit.open({ kind = 'split' }) end, desc = "Open Neogit status popup" },
      { '<leader>gc', function() neogit.open({ 'commit' }) end,       desc = "Open Neogit commit popup" },
      { '<leader>gp', function() neogit.open({ 'push' }) end,         desc = "Open Neogit push popup" },
      { '<leader>gb', function() neogit.open({ 'branch' }) end,       desc = "Open Neogit branch + branch config popup" },
      { '<leader>gd', function() neogit.open({ 'diff' }) end,         desc = "Open Neogit diff popup" },
      { '<leader>gf', function() neogit.open({ 'fetch' }) end,        desc = "Open Neogit fetch popup" },
      { '<leader>gl', function() neogit.open({ 'log' }) end,          desc = "Open Neogit log popup" },
      { '<leader>gm', function() neogit.open({ 'merge' }) end,        desc = "Open Neogit merge popup" },
      { '<leader>gP', function() neogit.open({ 'pull' }) end,         desc = "Open Neogit pull popup" },
      { '<leader>gr', function() neogit.open({ 'rebase' }) end,       desc = "Open Neogit rebase popup" },
      { '<leader>gR', function() neogit.open({ 'remote' }) end,       desc = "Open Neogit remote popup" },
      { '<leader>gS', function() neogit.open({ 'reset' }) end,        desc = "Open Neogit reset popup" },
      { '<leader>gT', function() neogit.open({ 'stash' }) end,        desc = "Open Neogit stash popup" },
      { '<leader>gt', function() neogit.open({ 'tag' }) end,          desc = "Open Neogit tag popup" },
      { '<leader>gw', function() neogit.open({ 'worktree' }) end,     desc = "Open Neogit worktree popup" },
    }
  end
  -- IMPORTANT: NOT RECOMMENDED:
  -- Automatically, there are a set of keymaps for 'lazygit',
  -- if you don't have the exectuable for this program within your $PATH,
  -- these keymaps will be useless.
}
