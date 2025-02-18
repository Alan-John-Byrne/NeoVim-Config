return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && npm install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  ft = { "markdown" },
  config = function()
    -- Keymaps for MarkdownPreview commands:
    vim.keymap.set("n", "<leader>m", "<cmd>MarkdownPreview<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>M", "<cmd>MarkdownPreviewStop<CR>", { noremap = true, silent = true })
  end,
}
