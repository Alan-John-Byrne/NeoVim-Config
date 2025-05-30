-- PLUGIN: The 'noice.nvim' plugin provides better notifications within the editor.
return {
  "folke/noice.nvim",
  dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
  init = function()
    vim.opt.lazyredraw = false
    -- XXX: Defining a custom command to capture and display shell output:
    vim.api.nvim_create_user_command('S', function(opts)
      local output = vim.fn.system(opts.args)
      vim.notify(output, vim.log.levels.INFO, { title = "<< Shell Command Output >>" })
    end, { nargs = '+' })
    -- XXX: Add an autocommand to detect :! commands and show a warning
    vim.api.nvim_create_autocmd("ShellCmdPost", {
      pattern = "*",
      callback = function()
        vim.notify("Warning: Use :S instead of :! for shell commands.", vim.log.levels.WARN,
          { title = "!! Shell Command Warning !!" })
      end,
    })
  end,
  opts = {
    -- SECTION: Part 1: Route setup.
    -- INFO: Routes check for a particular event using a 'filter', which then invokes a set view.
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
    },
    -- SECTION: Part 2: Configuring views.
    -- INFO: We choose how a view is displayed / configured.
    views = {
      -- NOTE:Using default settings. (i.e.: Leave empty)
    },
    -- SECTION: Part 3: Default views.
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
    -- SECTION: Part 4: Handle messages sent from 'vim.notify()'
    -- INFO: This handles what type of view is used when using the 'vim.notify()' method.
    notify = {
      enabled = true,  -- Yes, we want this activated.
      view = "notify", -- NOTE: The view 'notify' will be used from the above views table.
    },
    -- SECTION: Part 5: Styling LSP events.
    -- INFO:Sometime's LSPs send events and we can control how that information is displayed.
    lsp = {
      progress = {        -- > Show status updates like loading / indexing from an LSP serveer. (e.g.: Loading index.)
        enabled = true,
        view = "mini",    -- Using the 'mini' view from the above views table. NOTE: The 'mini' view is non-instrusive.
      },
      hover = {           -- > Show hover tooltips.
        enabled = true,
        silent = true,    -- Stop hover errors if there's nothing under the cursor.
        view = nil,       -- Default Neovim hover window.
      },
      signature = {       -- > Shows signature help as you type.
        enabled = true,
        auto_open = {     -- Show signature help automatically (i.e: Without Ctrl-K)
          enabled = true,
          trigger = true, -- Triggers when you type the first '(', then it will show.
          luasnip = true,
        },
        view = nil, -- Default Neovim hover window.
      },
      message = {   -- > Handles 'window'/'showMessage' events from LSP servers.
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
    -- SECTION: Part 6: Replacing original command-line at the bottom of Neovim.
    --  INFO: We can control how exactly this nicer version of the command-line looks.
    cmdline = {
      enabled = true, -- enables this improvement.
      format = {
        cmdline = { pattern = "^:", icon = "", lang = "vim" },
        void = { pattern = "^:!", icon = "", lang = "vim" }, -- IMPORTANT: Remove broken shell prompt.
        powershell = { pattern = "^:S ", icon = "$", lang = "ps1" }, -- 'lang' gives us PowerShell treesitter highlighting.
        search_down = { pattern = "^/", icon = "🔍", lang = "regex" },
        search_up = { pattern = "^%?", icon = "🔍", lang = "regex" },
        lua = { pattern = "^:lua ", icon = "", lang = "lua" },
      },
      view = "cmdline", -- NOTE: The view 'cmdline' will be used from the above views table. It displays it at the bottom, like in regular vim.
    },
  },
}
