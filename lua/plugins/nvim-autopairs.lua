-- PLUGIN: The 'nvim-autopairs' plugin auto-generates a matching closing pair for any bracket type.
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = true, -- WARN: Some plugins (like this one) require you to specify that you wish to use the default settings in the config.
}
