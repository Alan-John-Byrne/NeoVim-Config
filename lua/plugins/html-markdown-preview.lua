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
  -- PLUGIN: The 'live-preview.nvim' plugin provides both an html & markdown previewer similar to live server in vscode.
  -- WARN: Obsidian admonitions (callouts), are not supported here for markdown, that's why we use 'render-markdown.nvim' above.
  {
    'brianhuster/live-preview.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    keys = {
      { "<leader>ms", "<cmd>LivePreview start<CR>", mode = { "n" }, desc = "Start Browser Previewer" },
      { "<leader>mS", "<cmd>LivePreview close<CR>", mode = { "n" }, desc = "Stop Browser Previewer" },
    },
  }
}
