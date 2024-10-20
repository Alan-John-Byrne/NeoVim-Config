-- PLUGIN: Installing the 'markdown-preview.nvim' plugin. It allows for previewing markdown files within a browser.
return {
  "iamcco/markdown-preview.nvim",
  enabled = false, -- TESTING
  -- NOTE: Setting the commands to be used when interacting with markdown preview.
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  keys = {
    { "<leader>m", "<cmd>MarkdownPreview<CR>", desc = "Open Markdown Preview" },
  },
}
