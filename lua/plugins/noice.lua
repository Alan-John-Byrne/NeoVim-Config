-- PLUGIN: The 'noice.nvim' plugin provides better notifications within the editor.
return {
  -- SECTION: Part 0: Pre-configuring nvim-notofy setup.
  {
    "rcarriga/nvim-notify",
    enabled = true,
    config = function()
      require("notify").setup({
        background_colour = "#ffffff",
      })
    end
  },
  -- SECTION: Part 1: Setting up Noice pre-requisites.
  {
    "folke/noice.nvim",
    enabled = true,
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify", "nvim-telescope/telescope.nvim" },
    init = function()
      vim.opt.lazyredraw = false
    end,
    opts = {
      -- SECTION: Part 2: Route setup for filters.
      -- INFO: Routes check for a particular event using a 'filter', which then invokes a set view.
      -- WARN: Use only what's necessary in filter. The more specific you get, the more brittle the filter becomes.
      -- Prefer short, unique identifiers like a function name, filename, or part of the message / error text.
      routes = {
        {                                                -- Suppressing external command outputs.
          filter = { event = "msg_show", find = ":!" },  -- IMPORTANT: Remove broken shell output.
          opts = { skip = true },                        -- Don't do anything with it.
        },
        {                                                -- Looking for updated command prompt.
          filter = { event = "msg_show", find = ":S " }, -- NOTE: Add better command.
          view = "notify"                                -- Sending it's output to the 'notify' view.
        },
        {                                                -- Shift-k lsp filter.
          filter = { event = "notify", find = "No information available" },
          opts = { skip = true },                        -- Don't do anything with it.
        },
        {                                                -- Linter & Formater Only Filter (If not using full LSP).
          filter = { event = "notify", find = "Format request failed, no matching language servers" },
          opts = { skip = true },                        -- Don't do anything with it.
        },
        {                                                -- Removing annoying before and after save messages using regex.
          filter = { event = "msg_show", any = { { find = "%d+L, %d+B" }, { find = "; after #%d+" }, { find = "; before #%d+" }, }, },
          opts = { skip = true },                        -- Don't do anything with it.
        },
        {                                                -- Removing annoying forward slash error
          filter = { event = "notify", find = "cmp/entry.lua", },
          opts = {                                       -- Don't do anything with it.
            skip = true,
          },
        }

      },
      -- SECTION: Part 3: Configuring views.
      -- INFO: We choose how a view is displayed / configured.
      views = {
        hover = {              -- The LSP 'hover' view.
          border = {
            style = "rounded", -- or "single", "double", "solid", "shadow"
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
        },
      },
      -- SECTION: Part 4: Default views.
      -- INFO: If we don't have a matching route, then we use these.
      messages = {
        enabled = true, -- Yes, we want these default view routes activated.
        -- WARN: If you enabled messages, then the cmdline is enabled automatically.
        -- This is a current Neovim limitation.
        view = "notify",             -- view for normal messages
        view_error = "notify",       -- view for errors
        view_warn = "notify",        -- view for warnings
        view_history = "messages",   -- view for :messages
        view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
      },
      -- SECTION: Part 5: Handle messages sent from 'vim.notify()', use 'nvim-notify' instead.
      -- INFO: This handles what type of view is used when using the 'vim.notify()' method.
      notify = {
        enabled = true,  -- Yes, we want this activated.
        view = "notify", -- NOTE: The view 'notify' will be used from the above views table.
      },
      -- SECTION: Part 6: Styling LSP events.
      -- INFO:Sometime's LSPs send events and we can control how that information is displayed.
      lsp = {
        hover = { -- NOTE: Using the 'hover' view form above.
          enabled = true,
          view = "hover",
        },
        progress = {        -- > Show status updates like loading / indexing from an LSP serveer. (e.g.: Loading index.)
          enabled = true,
          view = "mini",    -- Using the 'mini' view from the above views table. NOTE: The 'mini' view is non-instrusive.
        },
        signature = {       -- > Shows signature help as you type.
          enabled = true,
          auto_open = {     -- Show signature help automatically (i.e: Without Ctrl-K)
            enabled = true,
            trigger = true, -- Triggers when you type the first '(', then it will show.
            luasnip = true,
          },
          view = "hover", -- Using the 'hover' view form above.
        },
        message = {       -- > Handles 'window'/'showMessage' events from LSP servers.
          enabled = true,
          view = "notify",
          opts = {},
        },
        override = {
          -- override the default lsp markdown formatter with Noice
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          -- override the lsp markdown formatter with Noice
          ["vim.lsp.util.stylize_markdown"] = true,
          -- override cmp documentation with Noice (needs the other options to work)
          ["cmp.entry.get_documentation"] = true,
        },
      },
      -- SECTION: Part 7: Replacing original command-line at the bottom of Neovim.
      --  INFO: We can control how exactly this nicer version of the command-line looks.
      cmdline = {
        enabled = true, -- enables this improvement.
        format = {
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          void = { pattern = "^:!", icon = "", lang = "vim" }, -- IMPORTANT: Remove broken shell prompt.
          bash = { pattern = "^:S ", icon = "$", lang = "bash" }, -- 'lang' gives us bash treesitter highlighting.
          search_down = { pattern = "^/", icon = "🔍", lang = "regex" },
          search_up = { pattern = "^%?", icon = "🔍", lang = "regex" },
          lua = { pattern = "^:lua ", icon = "", lang = "lua" },
        },
        view = "cmdline", -- NOTE: The view 'cmdline' will be used from the above views table. It displays it at the bottom, like in regular vim.
      },
    },
  }
}
