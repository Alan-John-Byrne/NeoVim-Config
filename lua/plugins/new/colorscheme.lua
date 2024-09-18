-- Configuring LazyVim to load gruvbox
return {
  "LazyVim/LazyVim",
  dependencies = {
    "ellisonleao/gruvbox.nvim",
  },
  -- Adding the Gruvbox colorscheme.
  opts = {
    colorscheme = "gruvbox",
  },
}
