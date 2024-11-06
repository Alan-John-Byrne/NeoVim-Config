--  PLUGIN: Overwriting the 'noice.nvim' plugin to fix annoying notification.
return {
  "folke/noice.nvim",
  enabled = true, --TESTING
  opts = function(_, opts) -- IMPORTANT: Extending original options table in base config for 'noice' plugin.
    table.insert(opts.routes, {
      -- Adding my own custom route to remove the "No informatoin available" notification.
      filter = {
        event = "notify",
        find = "No information available",
      },
      opts = { skip = true },
    })
  end,
}
