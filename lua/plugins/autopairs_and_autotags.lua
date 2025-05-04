-- PLUGIN:(S) The 'nvim-autopairs' plugin auto-generates a matching closing pair for any bracket / delimeter type.
-- The 'nvim-ts-autopairs' plugin auto-generates a matching closing pair for any html, jsx or tsx tag type.
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = {
    "windwp/nvim-ts-autotag"
  },
  config = function()
    require("nvim-autopairs").setup({}) -- WARN: Some plugins (like these ones) require you to specify that you wish to use the default settings in the config.
    require("nvim-ts-autotag").setup({})
  end
}
