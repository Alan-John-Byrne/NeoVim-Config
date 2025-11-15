-- PLUGIN: The 'bufferline.nvim' plugin provides tabular functionality at the top of every buffer for switching between buffers.
return {
  "akinsho/bufferline.nvim",
  enabled = true,
  event = "VeryLazy",
  init = function()
    -- WARN: For 'true color support' (when the plugin [the bufferline]
    -- infers it's highlight groups from your chosen theme), the 'termguicolors'
    -- option must be set prior to the 'bufferline' plugin being setup.
    -- INFO: Need this for configuring highlight groups.
    vim.opt.termguicolors = true
  end,
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle Pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>",           desc = "Delete Buffers to the Right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>",            desc = "Delete Buffers to the Left" },
    { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
    { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
    { "[b",         "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
    { "]b",         "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
    { "[B",         "<cmd>BufferLineMovePrev<cr>",             desc = "Move buffer prev" },
    { "]B",         "<cmd>BufferLineMoveNext<cr>",             desc = "Move buffer next" },
  },
  opts = {
    options = { -- TODO: See ':h bufferline-configuration' for more options.
      numbers = 'ordinal',
      diagnostics = 'nvim_lsp',
      -- IMPORTANT: Changing the below style could mean having
      -- to alter seperator colours.
      separator_style = 'slant' -- TODO: See ':h bufferline-styling' for more info on styles.
    },
    highlights = {              -- TODO: See ':h bufferline-highlight' for more info on highlight groups.
      --WARN:
      -- For when deciding on which highlight groups:
      -- fg means 'Text',
      -- bg means 'Background behind the Text'
      -- IMPORTANT: Incorrect Setting:
      -- fill = {
      --   fg = 'CursorLine',
      --   bg = 'CursonColumn'
      -- },
      -- INFO:
      -- Unpopulated space on the bufferline.
      fill = {
        bg = { -- Only 'bg' applies here.
          attribute = "bg",
          highlight = "WinBar"
        },
      },
      -- INFO:
      -- Currently opened buffer seperator
      -- colours.
      separator_selected = {
        fg = {
          attribute = "bg",
          highlight = "WinBar"
        },
        bg = {
          attribute = "bg",
          highlight = "PMenu"
        },
      },
      -- INFO:
      -- Seperator colours for buffers you
      -- are NOT currently viewing.
      separator = {
        fg = {
          attribute = "bg",
          highlight = "WinBar"
        },
        bg = {
          attribute = "bg",
          highlight = "WinBar"
        },
      },
      -- INFO:
      -- Seperator colours for the previously
      -- opened buffer.
      separator_visible = {
        fg = {
          attribute = "bg",
          highlight = "WinBar"
        },
        bg = {
          attribute = "bg",
          highlight = "PMenu"
        },
      },
      -- INFO:
      -- The colour the buffer you're
      -- currently viewing, is.
      buffer_selected = {
        fg = {
          attribute = "fg",
          highlight = "PMenu"
        },
        bg = {
          attribute = "bg",
          highlight = "PMenu"
        },
        bold = true,
        italic = true,
      },
      -- INFO:
      -- The colour of the buffers you are NOT
      -- currently viewing.
      background = {
        fg = { -- The text of those buffers.
          attribute = "fg",
          highlight = "WinBar"
        },
        bg = { -- The background of those buffers.
          attribute = "bg",
          highlight = "WinBar"
        },
      },
      -- INFO:
      -- The previously entered buffer.
      buffer_visible = {
        fg = {
          attribute = "fg",
          highlight = "PMenu"
        },
        bg = {
          attribute = "bg",
          highlight = "PMenu"
        },
      },
      -- INFO:
      -- The colour the 'exit' button will be
      -- on the buffer you're currently viewing.
      close_button_selected = {
        fg = {
          attribute = "fg",
          highlight = "Question"
        },
        bg = {
          attribute = "bg",
          highlight = "PMenu"
        },
      },
      -- INFO:
      -- The colour the 'exit' button will be
      -- when you are NOT looking at it's buffer.
      close_button = {
        fg = {
          attribute = "fg",
          highlight = "Question"
        },
        bg = {
          attribute = "bg",
          highlight = "WinBar"
        },
      },
      -- INFO:
      -- The colour the 'exit' button of
      -- the previously opened buffer.
      close_button_visible = {
        fg = {
          attribute = "fg",
          highlight = "PMenu"
        },
        bg = {
          attribute = "bg",
          highlight = "PMenu"
        },
      },
      -- INFO:
      -- The colour the number of the buffer will be
      -- when you are currently viewing that buffer.
      numbers_selected = {
        fg = {
          attribute = "fg",
          highlight = "PMenu"
        },
        bg = {
          attribute = "bg",
          highlight = "PMenu"
        },
      },
      -- INFO:
      -- The colour the number of the buffer will be
      -- when you are NOT viewing that buffer.
      numbers = {
        fg = {
          attribute = "fg",
          highlight = "WinBar"
        },
        bg = {
          attribute = "bg",
          highlight = "WinBar"
        },
      },
      -- INFO:
      -- The colour the number of the buffer
      -- opened previously.
      numbers_visible = {
        fg = {
          attribute = "fg",
          highlight = "PMenu"
        },
        bg = {
          attribute = "bg",
          highlight = "PMenu"
        },
      },
      -- INFO:
      -- The colour the modified icon will be
      -- when you are currently viewing that changed
      -- / altered buffer.
      modified_selected = {
        fg = {
          attribute = "fg",
          highlight = "Title"
        },
        bg = {
          attribute = "bg",
          highlight = "PMenu"
        },
      },
      -- INFO:
      -- The colour the modified icon will be
      -- when you are NOT viewing that changed
      -- / altered buffer.
      modified = {
        fg = { -- 'fg' here is always ignored for some reason.
          attribute = "fg",
          highlight = "Title"
        },
        bg = {
          attribute = "bg",
          highlight = "WinBar"
        },
      },
      -- INFO:
      -- The colour of the tab you are
      -- currently viewing.
      tab_selected = {
        fg = {
          attribute = "fg",
          highlight = "PMenu"
        },
        bg = {
          attribute = "bg",
          highlight = "PMenu"
        },
      },
      -- INFO:
      -- The colour of the tabs you are
      -- NOT currently viewing.
      tab = {
        fg = {
          attribute = "fg",
          highlight = "WinBar"
        },
        bg = {
          attribute = "bg",
          highlight = "WinBar"
        },
      },
      -- INFO:
      -- The colour of the tab seperator of the
      -- tab you are currently viewing.
      tab_separator_selected = {
        fg = {
          attribute = "bg",
          highlight = "WinBar"
        },
        bg = {
          attribute = "bg",
          highlight = "PMenu"
        },
        sp = {
          attribute = "fg",
          highlight = "WinBar"
        },
      },
      -- INFO:
      -- The colour of the tab seperators of the
      -- tabs you are NOT currently viewing.
      tab_separator = {
        fg = {
          attribute = "bg",
          highlight = "WinBar"
        },
        bg = {
          attribute = "bg",
          highlight = "WinBar"
        },
      },
      -- INFO:
      -- The close button of the currently
      -- opened tab.
      tab_close = {
        fg = {
          attribute = "fg",
          highlight = "Question"
        },
        bg = {
          attribute = "bg",
          highlight = "WinBar"
        },
      },
      -- INFO:
      -- Current Buffer name when
      -- linting warning messages are shown.
      warning_selected = {
        fg = {
          attribute = "fg",
          highlight = "MoreMsg"
        },
        bg = {
          attribute = "bg",
          highlight = "PMenu"
        },
      },
      -- INFO:
      -- Other Buffer names when linting
      -- warning messages are shown in them.
      warning = {
        fg = {
          attribute = "fg",
          highlight = "MoreMsg"
        },
        bg = {
          attribute = "bg",
          highlight = "WinBar"
        },
      },
      -- INFO:
      -- Buffer name linting error colour
      -- for the previously opened buffer.
      warning_visible = {
        fg = {
          attribute = "fg",
          highlight = "MoreMsg"
        },
        bg = {
          attribute = "bg",
          highlight = "PMenu"
        },
      },
      -- INFO:
      -- Current Buffer name when
      -- linting error messages are shown.
      error_selected = {
        fg = {
          attribute = "fg",
          highlight = "WarningMsg"
        },
        bg = {
          attribute = "bg",
          highlight = "PMenu"
        },
      },
      -- INFO:
      -- Other Buffer names when linting
      -- error messages are shown in them.
      error = {
        fg = {
          attribute = "fg",
          highlight = "WarningMsg"
        },
        bg = {
          attribute = "bg",
          highlight = "WinBar"
        },
      },
      -- INFO:
      -- Buffer name linting error colour
      -- for the previously opened buffer.
      error_visible = {
        fg = {
          attribute = "fg",
          highlight = "WarningMsg"
        },
        bg = {
          attribute = "bg",
          highlight = "PMenu"
        },
      },
    }
  }, -- Calling bufferline.setup({}) for initialization.
}
