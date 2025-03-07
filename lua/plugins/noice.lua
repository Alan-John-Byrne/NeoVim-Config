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
    messages = {
      -- NOTE: If you enable messages, then the cmdline is enabled automatically.
      -- This is a current Neovim limitation.
      enabled = true,              -- enables the Noice messages UI
      view = "notify",             -- default view for messages
      view_error = "notify",       -- view for errors
      view_warn = "notify",        -- view for warnings
      view_history = "messages",   -- view for :messages
      view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true,         -- use a classic bottom cmdline for search
      command_palette = true,       -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false,           -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false,       -- add a border to hover docs and signature help
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
          any = { -- Removing annoying before and after save messages using regex.
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
