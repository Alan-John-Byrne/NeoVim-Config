-- PLUGIN:(S):
-- * The 'nvim-autopairs' plugin auto-generates a matching closing pair for any bracket / delimeter type.
-- * The 'nvim-ts-autotag' plugin provides automatic closing and renaming of HTML, XML, and JSX tags using nvim-treesitter.
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = {
    "windwp/nvim-ts-autotag"
  },
  config = function()
    -- WARN: Some plugins (like these ones) require you to specify that you wish to use the default settings in the config.
    require("nvim-autopairs").setup({})
    require("nvim-ts-autotag").setup({})
  end
}
