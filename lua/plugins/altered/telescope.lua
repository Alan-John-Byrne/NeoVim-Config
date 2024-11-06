--  PLUGIN: Overwriting the 'telescope.nvim' plugin to fix keymaps.
return {
  "nvim-telescope/telescope.nvim",
  enabled = true, --TESTING
  keys = {
    --  IMPORTANT: Removing the conflicting keymap(s).
    { "<leader>gc", false },
  },
}
