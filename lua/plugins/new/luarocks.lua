-- PLUGIN: Installing the 'luarocks.nvim' plugin. It allows for easy integration of lua packages straight into neovim.
return {
  "vhyrro/luarocks.nvim",
  enabled = true, --TESTING
  priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
  config = true,
}
