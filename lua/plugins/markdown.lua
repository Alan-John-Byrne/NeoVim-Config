return {
  -- PLUGIN: The 'render-markdown.nvim' plugin allows for previewing live changes to a markdown file whilst still located in the file. (e.g.: 'README' files)
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },
    cmd = { "RenderMarkdown", "RenderMarkdown toggle", "RenderMarkdown preview" },
    enabled = true,
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    ft = { "markdown" },
    keys = {
      { "<leader>mt", "<cmd>RenderMarkdown toggle<CR>",  mode = { "n" }, desc = "Toggle Render" },
      { "<leader>mp", "<cmd>RenderMarkdown preview<CR>", mode = { "n" }, desc = "Show Rendered Side-Buffer" },
    },
    opts = {},
  },
  -- PLUGIN: The 'markdown-preview.nvim' plugin provides a markdown previewer similar to live server in vscode.
  -- IMPORTANT: Some plugins are written purely in VimScript (sometimes combined with other languages depending on the plugins purpose)
  -- like this one. They set global variables instead of exposing a lua module. So, here you CANNOT 'require' this module and pass an 'opts'
  -- table from above into a 'setup' function within this config function. You must alter settings for this kind of plugin EITHER via the 'vim.g'
  -- settings in lua.config.options, or within an 'init' function like above.
  {
    "iamcco/markdown-preview.nvim",
    enabled = true,
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_close = 0 -- 'markdown-preview': Set to 0 so preview window doesn't close when entering another buffer.
    end,
    ft = { "markdown" },
    keys = {
      { "<leader>mm", "<cmd>MarkdownPreview<CR>",     mode = { "n" }, desc = "Open Web Viewer",  noremap = true, silent = true },
      { "<leader>mM", "<cmd>MarkdownPreviewStop<CR>", mode = { "n" }, desc = "Close Web Viewer", noremap = true, silent = true },
    },
    config = function()
    end, -- WARN: You can only use 'config = true' here specifically for the 'markdown-preview.nvim' plugin.
  }
}
