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
      -- FIX: This below keybinding (<leader>ms) is used to stop the previous previewer, and start
      -- a new one for the current buffer. Otherwise an error would be thrown.
      -- INFO: A change had to be within the 'noice.nvim' plugin to ignore the following error, which
      -- would appear when using this keybinding:
      -- ERROR: "Port 5500 is being used by another process `nvim` (PID <number>). Run `:lua vim.uv.kill(<number>)`
      -- to kill it or change the port with `:lua LivePreview.config.port = <new_port>`"
      { "<leader>ms", "<CMD>LivePreview close<CR><CMD>LivePreview start<CR>", mode = { "n" }, desc = "Start Browser Previewer" },
      { "<leader>mS", "<CMD>LivePreview close<CR>",                           mode = { "n" }, desc = "Stop Browser Previewer" },
    },
  }
}
