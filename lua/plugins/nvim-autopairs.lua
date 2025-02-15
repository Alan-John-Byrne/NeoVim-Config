-- PLUGIN: The 'nvim-autopairs' plugin auto-generates a matching closing pair for any bracket type.
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = true,
  --  NOTE: use opts = {} for passing setup options
  -- this is equivalent to setup({}) function
}
