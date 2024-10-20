--  PLUGIN: Overwriting the 'telescope.nvim' plugin to fix keymaps.
return {
  "nvim-telescope/telescope.nvim",
  keys = {
    --  IMPORTANT: Removing the conflicting keymap(s).
    { "<leader>gc", false },
  },
}
