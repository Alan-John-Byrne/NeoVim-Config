--  PLUGIN: The 'whichpy.nvim' plugin provides a way to change between virtual environments for python scripts.
return {
  "neolooong/whichpy.nvim",
  enabled = true,
  dependencies = {
    -- optional for dap
    "mfussenegger/nvim-dap-python",
    -- optional for picker support
    "ibhagwan/fzf-lua",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>v", "<cmd>WhichPy select<cr>" }, -- Open picker on keymap
  },
  opts = {},
}
