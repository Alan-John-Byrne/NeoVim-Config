-- PLUGIN: The 'markdown-preview.nvim' plugin allows for previewing live changes to a markdown file. (e.g.: 'README' files)
return {
  "iamcco/markdown-preview.nvim",
  enabled = true,
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && npm install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_auto_close = 0 -- 'markdown-preview': Set to 0 so preview window doesn't close when entering another buffer.
  end,
  ft = { "markdown" },
  config = function()
    -- IMPORTANT: Some plugins are written purely in VimScript (sometimes combined with other languages depending on the plugins purpose)
    -- like this one. They set global variables instead of exposing a lua module. So, here you CANNOT 'require' this module and pass an 'opts'
    -- table from above into a 'setup' function within this config function. You must alter settings for this kind of plugin EITHER via the 'vim.g'
    -- settings in lua.config.options, or within an 'init' function like above.

    -- Keymaps for markdown-preview commands:
    vim.keymap.set("n", "<leader>m", "<cmd>MarkdownPreview<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>M", "<cmd>MarkdownPreviewStop<CR>", { noremap = true, silent = true })
  end,
}
