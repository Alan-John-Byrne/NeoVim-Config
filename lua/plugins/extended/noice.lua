return {
  "folke/noice.nvim",
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
