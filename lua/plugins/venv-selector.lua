-- PLUGIN: The 'venv-selector.nvim' plugin provides a way to change between virtual environments for EXCLUSIVELY python scripts.
return {
  "linux-cultist/venv-selector.nvim",
  enabled = true,
  dependencies = {
    "neovim/nvim-lspconfig",
    { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  },
  keys = {
    { "<leader>vv", "<cmd>VenvSelect<cr>",                                                                                                                            desc = "Python Env Select" },
    { "<leader>vi", "<cmd>lua local v=require('venv-selector').venv(); print(v and ('Virtual Environment in Use: ' .. v) or 'No virtual environment selected.')<CR>", desc = "Virtual Environment Used" },
  },
  opts = {
    search = {
      my_venvs = {
        command = "fd python$ ~/.local/share --full-path -HI -a -L -t f"
      }
    },
    options = {
      debug = true,
      enable_default_searches = true,
    }
  },
}
