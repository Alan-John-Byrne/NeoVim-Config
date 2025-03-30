-- PLUGIN: The 'gruvbox.nvim' plugin provides a much loved colorscheme.
return {
  "ellisonleao/gruvbox.nvim",
  --  lazy = false,
  config = function()
    vim.cmd.colorscheme("gruvbox")

    -- NOTE: Overriding global highlight-groups to remove solid background. (Opacity taken care of by WezTerm)
    vim.api.nvim_set_hl(0, 'Normal', { bg = nil })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = nil })
    vim.api.nvim_set_hl(0, 'NonText', { bg = nil })
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = nil })
    vim.api.nvim_set_hl(0, 'SignColumn', { bg = nil })
    vim.api.nvim_set_hl(0, 'WinBar', { bg = nil })
  end,
}
