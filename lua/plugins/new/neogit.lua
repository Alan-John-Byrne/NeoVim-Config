-- PLUGIN: Installing the 'neogit' plugin. It provides an interactive Git interface within Neovim, enabling users to perform Git operations directly from the editor.
return { -- XXX: PLUGIN BROKEN. DON'T USE. USE LAZYGIT.
  "NeogitOrg/neogit",
  enabled = true, -- TESTING
  event = { "VimEnter" }, --IMPORTANT: THIS 'event' argument is used to actual LOAD the plugin, into the current session.
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration
    "nvim-telescope/telescope.nvim", -- optional
  },
  config = true,
  keys = {
    { "<leader>gC", "<cmd>Neogit kind=split<CR>", desc = "Open Neogit status popup" },
    { "<leader>gc", "<cmd>Neogit commit<CR>", desc = "Open Neogit commit popup" },
    { "<leader>gp", "<cmd>Neogit push<CR>", desc = "Open Neogit push popup" },
    { "<leader>gb", "<cmd>Neogit bisect<CR>", desc = "Open Neogit bisect popup" },
    { "<leader>gB", "<cmd>Neogit branch<CR>", desc = "Open Neogit branch + branch config popup" },
    { "<leader>gd", "<cmd>Neogit diff<CR>", desc = "Open Neogit diff popup" },
    { "<leader>gf", "<cmd>Neogit fetch<CR>", desc = "Open Neogit fetch popup" },
    { "<leader>gl", "<cmd>Neogit log<CR>", desc = "Open Neogit log popup" },
    { "<leader>gm", "<cmd>Neogit merge<CR>", desc = "Open Neogit merge popup" },
    { "<leader>gP", "<cmd>Neogit pull<CR>", desc = "Open Neogit pull popup" },
    { "<leader>gr", "<cmd>Neogit rebase<CR>", desc = "Open Neogit rebase popup" },
    { "<leader>gR", "<cmd>Neogit remote<CR>", desc = "Open Neogit remote + remote config popup" },
    { "<leader>gS", "<cmd>Neogit reset<CR>", desc = "Open Neogit reset popup" },
    { "<leader>gT", "<cmd>Neogit stash<CR>", desc = "Open Neogit stash popup" },
    { "<leader>gt", "<cmd>Neogit tag<CR>", desc = "Open Neogit tag popup" },
    { "<leader>gw", "<cmd>Neogit worktree<CR>", desc = "Open Neogit worktree popup" },
  },
}

-- IMPORTANT: NOT RECOMMENDED:
-- WARN: LAZYVIM comes automatically set with some keymaps for 'lazygit', if you don't have the exectuable for this program installed on your system, these keymaps will be useless and take up space in the which-key menu.
-- TODO: To handle this issue, remove the section pertaining to lazygit within the below file in you nvim-data directory.
-- C:\Users\{username}\AppData\Local\nvim-data\lazy\LazyVim\lua\lazyvim\config\keymaps.lua
