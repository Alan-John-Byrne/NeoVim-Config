-- PLUGIN: Installing the 'markdown-preview.nvim' plugin. It allows for previewing markdown files within a browser.
return {
  "iamcco/markdown-preview.nvim",
  enabled = true, -- TESTING
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd C:\\Users\\alanj\\AppData\\Local\\nvim-data\\lazy\\markdown-preview.nvim && npm i", -- IMPORTANT: Must provide install location for build step.
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  ft = { "markdown" },
}
