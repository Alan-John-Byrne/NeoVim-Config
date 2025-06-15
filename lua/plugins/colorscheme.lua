-- PLUGIN: The 'gruvbox.nvim' plugin provides a much loved colorscheme.
return {
  -- "folke/tokyonight.nvim", Swap Whenever
  "ellisonleao/gruvbox.nvim",
  lazy = false, -- INFO: Illustrating that the colourscheme MUST NOT be 'lazy'.
  config = function()
    -- vim.cmd.colorscheme("tokyonight"), Swap Whenever
    vim.cmd.colorscheme("gruvbox") -- Loading the colourscheme.
    -- IMPORTANT: The following must be done AFTER loading the colourscheme.
    if (true) then
      -- WARN: Controlling nvim transparency, and managing suitable colour combinations for
      -- plugins such as 'bufferline.nvim'.
      -- NOTE: Overriding global highlight-groups to remove
      -- solid background. (Background Opacity taken care of
      -- by *WezTerm*).
      vim.api.nvim_set_hl(0, 'Normal', { bg = nil })      -- Removing color for entire Neovim window.
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = nil }) -- Removing color for Neovim hover windows.
      vim.api.nvim_set_hl(0, 'SignColumn', { bg = nil })  -- Removes annoying white box in number bar around icons.
      -- REMEMBER: 'vim.api' is Neovim's API. It's used by plugins,
      -- Lua, and vimscript.
    end
  end,
}
