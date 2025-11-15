-- PLUGIN: The 'lualine.nvim' plugin provides fancy status line at the bottom of the buffer window.
return {
  "nvim-lualine/lualine.nvim",
  enabled = true,
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      disabled_filetypes = {                 -- Filetypes to disable lualine for.
        statusline = { "snacks_dashboard" }, -- only ignores the ft for statusline.
        winbar = { "snacks_dashboard" },     -- only ignores the ft for winbar.
      },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { 'filename' },
      lualine_x = {
        { -- NOTE: Component for showing you're current input.
          -- TODO: Only if loaded, and there's content, return it to this section of the lualine.
          function() return require("noice").api.status.command.get() end,
          cond = function()
            -- WARN: Ensuring the noice plugin / package is first loaded.
            return package.loaded["noice"] and require("noice").api.status.command.has()
          end,
          color = { fg = "#ff9e64" },
        },
        { -- NOTE: Component for showing when you're recording a marco (@recording?).
          -- TODO: Only if loaded, and there's content, return it to this section of the lualine.
          function() return require("noice").api.status.mode.get() end,
          cond = function()
            -- WARN: Ensuring the noice plugin / package is first loaded.
            return package.loaded["noice"] and require("noice").api.status.mode.has()
          end,
          color = { fg = "#ff9e64" },
        },
        'encoding',
        'fileformat',
        'filetype'
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
  },
}
-- Sections: You can customize each section of lua line.
--+-------------------------------------------------+
--| A | B | C                             X | Y | Z |
--+-------------------------------------------------+
