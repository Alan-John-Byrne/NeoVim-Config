-- PLUGIN: The 'noice.nvim' plugin provides better notifications within the editor.
return {
  -- SECTION: Part 0: Pre-configuring nvim-notify setup.
  {
    "rcarriga/nvim-notify",
    enabled = true,
    config = function()
      require("notify").setup({

        -- PART: Animation Style - key setting for fancy animations!
        -- OPTIONS: For 'stages':
        -- "fade_in_slide_out",
        -- "fade",
        -- "slide",
        -- "static"
        stages = "fade_in_slide_out",

        -- PART: Animation timing:
        timeout = 5000, -- How long (in milliseconds) notifications stay visible before fading out. "5000ms" => 5 seconds.
        fps = 60,       -- Frames per second for animations. 30 is optimal; higher values may appear too fast.

        -- PART: Visual Settings:
        background_colour = "#000000", -- Background color for notification windows. "#000000" => black, works well with transparency.
        render = "default",            -- Rendering style: "default" (full featured), "minimal" (compact), or "simple" (basic).
        top_down = true,               -- Stack notifications from top to bottom. "false" => bottom to top.

        -- PART: Size constraints:
        minimum_width = 50, -- Minimum width of notification window in characters
        max_width = 80,     -- Maximum width of notification window in characters.
        max_height = 10,    --Maximum height of notification window in lines.

        -- PART: Icons (optional, for better visual feedback):
        icons = {
          ERROR = "‼️", -- Icon shown for error-level notifications.
          WARN = "⚠️", -- Icon shown for warning-level notifications.
          INFO = "🔎", -- Icon shown for info-level notifications.
          DEBUG = "🔴", -- Icon shown for debug-level notifications.
          TRACE = "🚨", -- Icon shown for trace-level notifications.
        }

      })

      -- CONFIGURATION: Set as default notify handler.
      -- CRITICAL: This overrides Neovim's default vim.notify function to use nvim-notify instead.
      -- This ensures ALL notifications (from plugins, LSP, etc.) use nvim-notify's animations.
      -- TODO: Without this line, notifications would use Neovim's basic built-in notification system.
      vim.notify = require("notify")
    end
  },
  -- SECTION: Part 1: Setting up Noice pre-requisites.
  {
    "folke/noice.nvim",
    enabled = true,
    dependencies = { "MunifTanjim/nui.nvim", "linux-cultist/venv-selector.nvim", "rcarriga/nvim-notify", "nvim-telescope/telescope.nvim" }, -- NOTE: 'venv-selector.nvim' must be loaded first.
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
        -- FIX: Removing annoying forward slash error.
        {
          filter = { event = "notify", find = "cmp/entry.lua", },
          opts = { -- don't do anything with it.
            skip = true,
          },
        },
        -- FIX: Removing annoying 'port being used warning' from the html/markdown previewer plugin.
        {
          filter = { event = "notify", find = "Port.*is being used", },
          opts = {
            skip = true,
          },
        }

      },
      -- SECTION: Part 3: Configuring views.
      -- INFO: We choose how a view is displayed / configured.
      views = {
        -- CRITICAL: This 'notify' view configuration is required to correctly route
        -- all notifications through nvim-notify's animation system.
        notify = {             -- The 'notify' view configuration for nvim-notify animations.
          backend = "notify",  -- Use nvim-notify as the backend.
          fallback = "mini",   -- Fallback to 'mini' view if nvim-notify is unavailable.
          replace = false,     -- Don't replace existing notifications (allows animations to complete).
          merge = false,       -- Don't merge similar messages (each gets its own animation).
        },
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
        progress = { -- > Show status updates like loading / indexing from an LSP serveer. (e.g.: Loading index.)
          enabled = true,
          -- OPTIONS: For 'view':
          -- The 'mini' view is non-instrusive.
          -- The 'notify' view enables LSP progress messages to have animations configured with the nvim-notify plugin.
          -- > These views come from the above views table.
          view = "mini",
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
