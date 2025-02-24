-- PLUGIN: The 'noice.nvim' plugin provides better notifications within the editor.
return {
  "folke/noice.nvim",
  event = "VeryLazy", -- NOTE: 'VeryLazy' only loads the plugin when needed (On powershell files).
  -- IMPORTANT: 'VeryLazy' allows package managers (e.g.: lazy.nvim, Mason, etc...) to load the plugin ahead of time,
  -- so we can request them later within another plugins config functions. Otherwise we get errors saying a plugin 'doesn't
  -- exist', cause we create a race condition saying we need it to load the plugin before even it's package manager has a chance to load.
  dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
  init = function()
    vim.opt.lazyredraw = false
  end,
  opts = {
    messages = { view = "notify", view_warn = "notify" },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = true,
      lsp_doc_border = true,
    },
    cmdline = {
      view = "cmdline", -- NOTE: Displaying the cmdline at the bottom, like in regular vim.
    },
    routes = {          -- WARN: Filters for skipping annoying noice notifications that mean nothing.
      {
        filter = {
          event = "notify",
          find = "No information available", -- Shift-k lsp filter.
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "notify",
          find = "Format request failed, no matching language servers", -- Linter & Formater Only Filter (If not using full LSP).
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          any = { -- Whatever, I dunno what this is lol, some regex I dunno.
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
    },
  },
}
