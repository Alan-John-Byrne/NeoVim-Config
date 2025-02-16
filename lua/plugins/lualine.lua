-- PLUGIN: The 'lualine.nvim' plugin provides fancy status line at the bottom of the buffer window.
return {
  "nvim-lualine/lualine.nvim",
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
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
  },
}
-- Sections: You can customize each section of lua line.
--+-------------------------------------------------+
--| A | B | C                             X | Y | Z |
--+-------------------------------------------------+
