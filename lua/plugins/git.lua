return {
  -- PLUGIN: The 'neogit.nvim' plugin provides a better git project
  -- management expierence.
  {
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
    --  Automatically, there are a set of keymaps for 'lazygit',
    --  if you don't have the exectuable for this program within your PATH,
    --  these keymaps will be useless.
  },
  -- PLUGIN: The 'gitsigns.nvim' plugin provides provides visual aids within buffers contained within a git project.
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end
        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  -- PLUGIN: The 'git-conflict.nvim' plugin provides visualise and resolve functionalty.
  {
    'akinsho/git-conflict.nvim',
    version = "*",
    config = true
    -- NOTE: This plugin offers default buffer local mappings inside conflicted files.
    -- co — choose ours
    -- ct — choose theirs
    -- cb — choose both
    -- c0 — choose none
    -- ]x — move to previous conflict
    -- [x — move to next conflict
  }
}
