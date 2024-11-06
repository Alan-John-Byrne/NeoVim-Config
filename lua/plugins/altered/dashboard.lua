-- PLUGIN: Altering the 'dashboard.nvim' plugin, to change the logo to my name.
return {
  "nvimdev/dashboard-nvim",
  enabled = true, --TESTING
  opts = function(_, opts)
    local logo = [[
 █████╗ ██╗      █████╗ ███╗   ██╗    ██████╗ ██╗   ██╗██████╗ ███╗   ██╗███████╗
██╔══██╗██║     ██╔══██╗████╗  ██║    ██╔══██╗╚██╗ ██╔╝██╔══██╗████╗  ██║██╔════╝
███████║██║     ███████║██╔██╗ ██║    ██████╔╝ ╚████╔╝ ██████╔╝██╔██╗ ██║█████╗
██╔══██║██║     ██╔══██║██║╚██╗██║    ██╔══██╗  ╚██╔╝  ██╔══██╗██║╚██╗██║██╔══╝
██║  ██║███████╗██║  ██║██║ ╚████║    ██████╔╝   ██║   ██║  ██║██║ ╚████║███████╗
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝    ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝
]]
    logo = string.rep("\n", 8) .. logo .. "\n\n"
    opts.config.header = vim.split(logo, "\n")
    opts.theme = "doom"
  end,
}
