-- OOO: PROGRAMMING LANGUAGE CONFIGURATIONS:
-- INFO: ALL PLUGINS HERE WORK TOGETHER to provide multiple programming language support including features like
-- 'hover descriptions', 'debugging support', 'better text highlighting', 'Linting', 'Formatting', and 'Auto-Complete'.
return {
  -- SECTION: 0. Providing better hover for LSPs.
  -- PLUGIN: The 'pretty_hover' plugin provides a replacment to the default LSP hover window (vim.lsp.buf.hover).
  -- With a customizable, visually enhanced floating window using syntax-based highlighting, wrapping, and optional
  -- borders—all without modifying global highlight groups or LSP handlers. *Very Handy*
  {
    "Fildo7525/pretty_hover",
    config = function()
      require("pretty_hover").setup({
        -- NOTE:If you use nvim 0.11.0 or higher, you can choose whether you want to use the new
        -- multi-lsp support or not. Otherwise this option is ignored.
        multi_server = true,
        border = "rounded",
        wrap = true,
        max_width = nil,
        max_height = nil,
        toggle = false,
        -- OOO: Tables grouping the detected strings and using the markdown highlighters.
        header = {
          detect = { "[\\@]class" },
          styler = '###',
        },
        line = {
          detect = { "[\\@]brief" },
          styler = '**',
        },
        listing = {
          detect = { "[\\@]li" },
          styler = " - ",
        },
        references = {
          detect = { "[\\@]ref", "[\\@]c", "[\\@]name" },
          styler = { "**", "`" },
        },
        group = {
          detect = {
            -- NOTE: ["Group name"] = {"detectors"}
            ["Parameters"] = { "[\\@]param", "[\\@]*param*" },
            ["Types"] = { "[\\@]tparam" },
            ["See"] = { "[\\@]see" },
            ["Return Value"] = { "[\\@]retval" },
          },
          styler = "`",
        },
        -- OOO: Tables used for cleaner identification of hover segments.
        code = {
          start = { "[\\@]code" },
          ending = { "[\\@]endcode" },
        },
        return_statement = {
          "[\\@]return",
          "[\\@]*return*",
        },
        -- OOO: Highlight groups used in the hover method. Feel free to define your own highlight group.
        hl = {
          error = {
            color = "#DC2626",
            detect = { "[\\@]error", "[\\@]bug" },
            line = false, -- INFO: Flag detecting if the whole line should be highlighted.
          },
          warning = {
            color = "#FBBF24",
            detect = { "[\\@]warning", "[\\@]thread_safety", "[\\@]throw" },
            line = false,
          },
          info = {
            color = "#2563EB",
            detect = { "[\\@]remark", "[\\@]note", "[\\@]notes" },
          },
          --  INFO: Below, you can set up your own highlight groups.
        },
      })
      -- NOTE: Replacing original 'vim.lsp.buf.hover' keymap with pretty_hover.
      vim.keymap.set("n", "K", require("pretty_hover").hover, { desc = "Pretty hover" })
    end
  },
  -- SECTION: 1. Setup Tree-sitter (Language Parsing)
  -- PLUGIN: The 'nvim-treesitter' plugin provides better text highlighting, and also serves other core purposes for language support.
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    dependencies = {
      -- PERFORMANCE: Provides better text object highlighting,and provides many text
      -- object selection tools making life a lot easier and more convenient.
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment Selection" },
      { "<bs>",      desc = "Decrement Selection", mode = "x" },
    },
    opts_extend = { "ensure_installed" },
    config = function()
      -- TODO: Here you can configure different filetypes by extension and name so that treesitter parses
      -- them correctly for highlighting (done by treesitter itself) and linting + formatting (handled by
      -- the 'nvim-lint' and 'conform.nvim' plugins configured below, respectively).
      vim.filetype.add({
        -- OOO: Making Jenkinsfile(s) open using the groovy installed linters and formatters.
        filename = {
          ["Jenkinsfile"] = "groovy",
        },
        -- OOO: Adding support for 'plist' files to just be parsed as XML, by treesitter.
        -- WARN: Required for macOS setups.
        extension = {
          plist = "xml",
        },
      })
      -- OOO: Setting up various highlight configurations depending on filetype:
      local treesitter = require("nvim-treesitter.configs")
      treesitter.setup({
        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = {
          "bash",
          "c",
          "diff",
          "html",
          "javascript",
          "jsdoc",
          "json",
          "jsonc",
          "lua",
          "luadoc",
          "luap",
          "markdown",
          "markdown_inline",
          "printf",
          "python",
          "query",
          "regex",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "xml",
          "yaml",
          "robot"
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        textobjects = {
          move = {
            enable = true,
            goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
            goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
            goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
          },
        },
        auto_install = true,
        sync_install = false,
        modules = {},
        ignore_install = {}
      })
    end
  },
  -- SECTION: 2. Setting up Auto-Completions.
  -- PLUGIN:(S)
  -- * The 'luasnip' plugin provides a powerful and extensible snippet engine for Neovim,
  -- allowing users to insert and manage code snippets efficiently using Lua.
  -- * The nvim-cmp plugin is a completion engine for Neovim that provides intelligent autocompletion
  -- from multiple sources like LSP, buffers, paths, and snippets.
  {
    {
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      dependencies = {
        "L3MON4D3/LuaSnip",
        "onsails/lspkind.nvim",
      },
      config = function()
        -- nvim-cmp setup
        local cmp = require('cmp')
        -- PERFORMANCE: Lazy-loading in VSCode snippets for faster auto-completion.
        require("luasnip.loaders.from_vscode").lazy_load()
        local luasnip = require('luasnip')
        -- INFO: Custom VSCode Specific highlighting for auto-completion dropdown.
        vim.api.nvim_set_hl(0, "CMPMenuSel", { bg = "#2c313c", fg = "#ffffff" })
        vim.api.nvim_set_hl(0, "CMPMenu", { fg = nil, bg = nil })
        -- gray
        vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg = nil, strikethrough = true, fg = '#808080' })
        -- blue
        vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg = nil, fg = '#569CD6' })
        vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpIntemAbbrMatch' })
        -- light blue
        vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg = nil, fg = '#9CDCFE' })
        vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link = 'CmpItemKindVariable' })
        vim.api.nvim_set_hl(0, 'CmpItemKindText', { link = 'CmpItemKindVariable' })
        -- pink
        vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg = nil, fg = '#C586C0' })
        vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link = 'CmpItemKindFunction' })
        -- front
        vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg = nil, fg = '#D4D4D4' })
        vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link = 'CmpItemKindKeyword' })
        vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link = 'CmpItemKindKeyword' })
        -- Disabling incorrect 'misuse of `cmp.setup()`' warning:
        ---@diagnostic disable-next-line: redundant-parameter
        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = {
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          },
          sources = {
            { name = 'nvim_lsp' },
            { name = 'buffer' },
            { name = 'path' },
            { name = 'luasnip' },
          },
          window = {
            completion = {
              border = "rounded",
              -- PERFORMANCE: We must tell 'nvim-cmp' to use custom highlight groups
              -- (via 'winhighlight') instead of the *default* ones (i.e.: Normal, FloatBorder, CursorLine etc...).
              winhighlight = "Normal:CMPMenu,FloatBorder:CMPMenu,CursorLine:CMPMenuSel",
              col_offset = -3,
              side_padding = 0,
            },
            documentation = {
              border = "rounded",
              winhighlight = "Normal:CMPMenu,FloatBorder:CMPMenu,CursorLine:CMPMenuSel",
              col_offset = -3,
              side_padding = 0,
            },
          },
          formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
              -- PERFORMANCE: Use Visual Studio Code Icons Instead, for styling auto-complete dropdown.
              if vim.tbl_contains({ 'path' }, entry.source.name) then
                local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
                if icon then
                  vim_item.kind = icon
                  vim_item.kind_hl_group = hl_group
                  return vim_item
                end
              else
                local lspkind_ok, _ = pcall(require, "lspkind")
                -- If not available use your own custom icons.
                if not lspkind_ok then
                  -- Define your own kind_icons to use instead.
                  local kind_icons = {
                    Text = "",
                    Method = "",
                    Function = "",
                    Constructor = "",
                    -- etc...
                  }
                  -- From kind_icons array
                  vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
                  -- Source
                  vim_item.menu = ({
                    buffer = "[Buffer]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[LuaSnip]",
                    nvim_lua = "[Lua]",
                    latex_symbols = "[LaTeX]",
                  })[entry.source.name]
                  return vim_item
                  -- If available, use lspkind.
                else
                  -- Default to using the lspkind.nvim plugin for styling auto-complete dropdown, if 'path' not present.
                  local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
                  local strings = vim.split(kind.kind, "%s", { trimempty = true })
                  kind.kind = " " .. (strings[1] or "") .. " "
                  kind.menu = "    (" .. (strings[2] or "") .. ")"
                  return kind
                end
              end
            end
          },
        })
      end,
    },
    {
      "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp.
      after = 'nvim-cmp',     -- Load after nvim-cmp
    },
    {
      'hrsh7th/cmp-buffer', -- Buffer source for cmp
      after = 'nvim-cmp',
    },
    {
      'hrsh7th/cmp-path', -- Path source for cmp
      after = 'nvim-cmp',
    },
    {
      'saadparwaiz1/cmp_luasnip', -- Snippet source for nvim-cmp
      after = 'nvim-cmp',
    },
    {
      'L3MON4D3/LuaSnip', -- -- LuaSnip (Loads snippets from VSCode).
      after = 'nvim-cmp',
    },
  },



  -- SECTION: 3. Setting up the 'nvim-lspconfig' plugin, and all it's associated plugins.
  -- PLUGIN: The 'nvim-lspconfig' plugin simplifies the setup and configuration of built-in
  -- Neovim LSP client support by providing pre-defined configurations for a wide range of language servers.
  {
    "neovim/nvim-lspconfig", -- NOTE: Handles LSP configurations. *This has been mostly replaced in Neovim v0.11 with the 'vim.lsp.config/enable' apis. But, is still used.
    event = "VeryLazy",      -- INFO: 'VeryLazy' only loads the plugin when needed.
    -- PERFORMANCE: 'VeryLazy' allows package managers (e.g.: lazy.nvim, Mason, etc...) to load the plugin ahead of time,
    -- so we can request them later within another plugins config functions. Otherwise we get errors saying a plugin 'doesn't
    -- exist', cause we create a race condition saying we need it to load the plugin before even it's package manager has a chance to load.
    enabled = true,
    dependencies = {
      -- TODO: Add Package / Plugin Management:
      "williamboman/mason.nvim",           -- Mason (LSP, DAP, Linters, Formatters).
      "williamboman/mason-lspconfig.nvim", -- Mason <-> nvim-lspconfig (LSP) bridge.
      "jay-babu/mason-nvim-dap.nvim",      -- Mason <-> nvim-dap bridge (Debug Adapter Protocols / DAPs).
      "rshkarin/mason-nvim-lint",          -- Mason <-> nvim-lint bridge (Linters).
      "zapling/mason-conform.nvim",        -- Mason <-> conform bridge (Formatters).
      "nvim-treesitter/nvim-treesitter",   -- Tree-sitter integration. (Syntax Highlighting)

      -- TODO: Add Core Plugins:
      "nvim-lua/plenary.nvim",  -- Required for various plugins.
      "nvim-neotest/nvim-nio",  -- Required for nvim-dap-ui.
      "mfussenegger/nvim-lint", -- nvim-lint (Linters).
      "stevearc/conform.nvim",  -- conform (Formatters).
      "mfussenegger/nvim-dap",  -- nvim-dap (Debug Adapter Protocols / DAPs).
      "rcarriga/nvim-dap-ui",   -- Debugging UI for nvim-dap.

      -- TODO: Setup Other Vital Plugins:
      "hrsh7th/nvim-cmp",                  -- nvim-cmp (Auto-Completion).Provides auto-completion support for many programming and markup languages.
      "theHamsta/nvim-dap-virtual-text",   -- Provides nice variable text when debugging.
      "jbyuki/one-small-step-for-vimkind", -- Debug adapter for 'lua' not provided by Mason package manager!
      "leoluz/nvim-dap-go",                -- Debug adapter for 'go' / 'golang' not provided by Mason package manager!

      -- LSP: Java (JDTLS)
      -- CONFIGURATION: Plugins Required:
      -- PLUGIN:(S) 'nvim-jdtls.nvim' extends the capabilities of the built-in LSP support in Neovim, to support Java (which includs debugging).
      -- NOTE: Enabling the pre-configured '~/.config/nvim/lsp/jdtls.lua' configuration, and attaching it to Java buffers.
      { 'mfussenegger/nvim-jdtls', enabled = true, dependencies = { 'mfussenegger/nvim-dap' }, }

    },
    init = function(plugin)
      -- PERFORMANCE: Add nvim-treesitter queries to the rtp and it's custom query predicates early.
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer triggers the **nvim-treesitter** module to be loaded in time. Luckily, the only
      -- things that those plugins need are the custom queries, which we make available
      -- *immediately* during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    config = function()
      -- SECTION: 4. Setup Mason (UI-Based Package Manager),
      -- PLUGIN: The 'mason.nvim' plugin is a Neovim plugin that provides a unified interface for managing external tools
      -- like LSP servers, DAP servers, linters, and formatters by handling their installation and updates.
      require("mason").setup()
      -- IMPORTANT: Ensure "~/.local/share/nvim/mason/bin" directory is accessible via the PATH. This is how
      -- 'bridge' plugins can access the plugins you install via the Mason UI, setup immediately below.

      -- SECTION: 5. Setup LSPs Handled *Externally* from Mason, using the new Neovim v0.11 'vim.lsp.config/enable' apis.
      -- INFO: These configurations can be found here -> "~/.config/nvim/lsp".
      vim.lsp.enable('robotcode')
      vim.lsp.enable('jdtls')

      -- SECTION: 6. Setup LSPs (Auto-Install + Auto-Config) - Handled by Mason automatically.
      -- PLUGIN: The 'mason-lspconfig.nvim' plugin bridges mason.nvim and 'nvim-lspconfig' by automatically configuring
      -- and ensuring installation of LSP servers from the Mason package manager, for use with the 'nvim-lspconfig' plugin.
      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls",
          "clangd",
          "jsonls",
          "lua_ls",
          "omnisharp",
          "powershell_es",
          "pyright",
          "ruff",
          "vtsls"
        }, -- Auto-install these LSPs
        automatic_enable = true,
      })

      -- OOO: Setting up all installed LSPs.
      local mason_lspconfig_test = require("mason-lspconfig")
      for _, server_name in ipairs(mason_lspconfig_test.get_installed_servers()) do
        -- OOO: Lua_ls LSP setup:
        if server_name == "lua_ls" then
          vim.lsp.config(server_name, { -- NOTE: Configure server via `vim.lsp.config()` (New in Neovim v0.11).
            settings = {
              Lua = {
                workspace = {
                  -- WARN: The 'lua_ls' lsp provides *SOME* linting. To allow it to
                  -- recognise the global 'vim' table / variable, we must pass the neovim
                  -- runtime library files into it's workspace library setting, via it's setup function.
                  -- REMEMBER: The 'selene' linter will do most of the linting for lua instead. (Setup below)
                  library = {
                    vim.api.nvim_get_runtime_file("", true),
                    -- IMPORTANT: This is a requirement. It allows the language server to see all the contents of 3rd party libraries you go onto add.
                    vim.env.VIMRUNTIME .. "/lua",
                    -- INFO: Including 3rd party libraries used by default in Neovim, so the lua_ls language server recognises them.
                    "${3rd}/luv/library", -- NOTE: This '${3rd}/<library-name>/library' is recognised by the lua_ls language server. Add to the list below if linter ever shows 'unrecognised' warnings.
                  },
                  checkThirdParty = false
                },
                -- Adjusting "hover over" behaviour for the 'lua_ls' LSP.
                hover = {
                  previewFields = 100 -- Expanding amount of rows viewable within module tables.
                },
                runtime = {
                  version = 'LuaJIT',
                },
                diagnostics = {
                  globals = {
                    'vim',
                    'require',
                  },
                },
                telemetry = {
                  enable = false
                },
                completion = {
                  callSnippet = "Replace",
                },
              },
            },
          })
          -- OOO: Just use default settings for all other LSPs.
        else
          vim.lsp.config(server_name, {})
        end
        -- TODO: You must activate the lsp.
        vim.lsp.enable(server_name)
      end

      -- SECTION: 7. Setup Linters & Formatters:
      -- INFO: Some function as both linters and formatters. (eg: markdownlint)
      -- REMEMBER: Linters & formatters ONLY kick into action when you save a buffer. (*Autocommands are used for this*)
      -- OOO: Linters:
      -- PLUGIN:(S)
      -- * The 'nvim-lint' plugin, is a lightweight plugin for asynchronous linting in Neovim using external linters, configured per filetype.
      -- * The 'mason-nvim-lint' plugin integrates Mason with the nvim-lint plugin, allowing for automatic installation and
      -- management of linters used by nvim-lint.
      require("lint").linters_by_ft = { -- Hook these Linters into Neovim.
        html = { "htmlhint" },
        markdown = { "markdownlint" },
        python = { "ruff" },
        lua = { "selene" },
        bash = { "shellcheck" },
        css = { "stylelint" },
      }

      require("mason-nvim-lint").setup({
        ensure_installed = {
          "htmlhint",
          "markdownlint",
          "ruff",
          "selene",
          "shellcheck",
          "stylelint"
        },
        automatic_installation = true,
        quiet_mode = false,
        ignore_install = {}
      })

      -- IMPORTANT: The 'npm-groovy-lint' linter/formatter requires a more verbose setup. (Auto-command Required)
      -- WARN: Only works as a formatter, the linter is broken.
      require("plugins.language_configurations.utility").npm_groovy_lint_setup()

      -- OOO: Linters Specific Settings; Customize a linters config via it's 'args' table.
      require("lint").linters.selene.args = {
        -- WARN: The 'selene' linter doesn't know about the neovim runtime
        -- global variables like the 'vim' table, but the 'lua_ls' lsp does.
        -- So, we provide a custom configuration for selene to just ignore it.
        "--config", vim.fn.stdpath("config") .. "lua/config/selene.toml"
      }

      require("lint").linters.markdownlint.args = {
        "--stdin", -- WARN: This is a required argument by this specifc linter. (Some linters require certain arguments to be passed.)
        "--disable",
        "MD013",
        "MD026",
        "MD049",
        "MD033",
        "MD029",
        "MD028"
      } -- NOTE: Please find full set of rules available for 'markdownlint' at:
      --   https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint

      -- IMPORTANT: Autocommand to trigger linters automatically.
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        pattern = { "*.lua", "*.md" },
        callback = function()
          require("lint").try_lint()
        end,
      })

      -- OOO: Formatters:
      -- PLUGIN:(S)
      -- * The 'conform.nvim' plugin is a lightweight and fast formatting plugin for Neovim that formats
      -- code using external tools, configured per filetype.
      -- * The 'mason-conform.nvim' plugin integrates Mason with conform.nvim, enabling automatic installation
      -- and management of formatters used by conform.nvim.
      require("conform").setup({ -- Hook these Formatters into Neovim.
        format_on_save = {
          timeout_ms = 5000,     -- Increased to 5 seconds. (Giving time for save operation ahead of format operation)
          lsp_fallback = true,   -- If no seperate formatter is installed, and an LSP takes care of formatting, use that instead.
        },
        formatters_by_ft = {
          lua = { "luaformatter" },
          markdown = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          go = { "goimports" },
          bash = { "beautysh" },
          python = { "ruff" },
          groovy = { "npm-groovy-lint" }
        },
      })

      require("mason-conform").setup({
        ensure_installed = {
          "luaformatter",
          "prettier",
          "goimports",
          "beautysh",
          "ruff",
          "npm-groovy-lint"
        },
        automatic_installation = true,
      })

      -- IMPORTANT: Autocommand to trigger formatters automatically on buffer content save.
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*", -- This applies to all files, you can change the pattern to a specific file type (e.g. "*.lua" or "*.md" etc)
        callback = function()
          -- REMEMBER: USE 'Lua_ls' LSP for better formatting.
          local bufnr = vim.api.nvim_get_current_buf()
          local clients = vim.lsp.buf_get_clients(bufnr)
          local lua_is_active = false
          for _, client in ipairs(clients) do
            if client.name == "lua_ls" then
              lua_is_active = true
            end
          end
          if lua_is_active then
            vim.lsp.buf.format({ async = false })                            -- Format using 'lua_ls' LSP. IMPORTANT: Must NOT be ASYNCHRONOUS, must FORMAT AFTER SAVING CONTENTS to buffer.
          else
            require("conform").format({ async = true, lsp_fallback = true }) -- This Triggers conform based formatters.
          end
        end,
      })



      -- SECTION: 7. Setup Debug Adapters (DAP)
      local language_configuration_utility = require("plugins.language_configurations.utility") -- Helper methods for setup.
      -- PLUGIN:(S)
      -- * The 'nvim-dap' ("dap") plugin enables debugging capabilities in Neovim by providing a client implementation
      -- of the Debug Adapter Protocol (DAP), allowing you to set breakpoints, step through code, and inspect variables.
      -- * The 'mason-nvim-dap' plugin automates the installation and configuration of DAP (Debug Adapter Protocol)
      -- servers that you've installed via the Mason package manager. This streamlines debugger setup in Neovim.
      local dap = require("dap") -- INFO: Used to set certain configuration settings within specific adapters.
      --  NOTE: 'mason-nvim-dap' allows us to also manually configure debug adapters & configurations for different languages.
      require("mason-nvim-dap").setup({
        ensure_installed = { "python", "codelldb", "js-debug-adapter" },
        automatic_installation = true,
      })

      -- INFO: JAVA DEBUG ADAPTER CONFIG:
      -- WARN: HANDLED BY THE NVIM-JDTLS PLUGIN, WITHIN IT'S CONFIG.

      -- INFO: GOLANG DEBUG ADAPTER CONFIG:
      -- PLUGIN: The dap-go plugin configures and integrates Go-specific debugging support for nvim-dap,
      -- simplifying setup and usage of the Delve debugger within Neovim.
      require("dap-go").setup() -- NOTE: Comes bundled with a working adapter configuration.

      -- INFO: LUA DEBUG ADAPTER CONFIG:
      -- IMPORTANT: DOES NOT SUPPORT PRINT TO DEBUG REPL WINDOW. USE 'Locals' WINDOW FOR SEEING EVALUATED VALUES OF VARIABLES.
      dap.adapters.nlua = function(callback, conf)
        local adapter = {
          type = "server",
          host = "127.0.0.1",
          port = 8086,
        }
        if conf.start_neovim then
          local dap_run = dap.run
          dap.run = function(dap_conf)
            adapter.port = dap_conf.port
            adapter.host = dap_conf.host
          end
          require("osv").run_this()
          dap.run = dap_run
        end
        callback(adapter)
      end

      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Run this file",
          start_neovim = {},
        },
      }

      -- INFO: C++ DEBUG ADAPTER CONFIG:
      -- IMPORTANT: MUST DO "g++ -g -o main *yourcppfile*.cpp" when building project. (If only compiling and debugging a single file.)
      -- WARN: The '-g' flag is *SUPER IMPORTANT*. It provides the symbols for the debugger. '-o' will output an executable called 'main.exe'.
      -- REMEMBER: The 'Ninja' build tools MUST be installed on your system, and entered into your system environment variables.
      -- It's required for clangd lsp.
      -- TODO: Set 'Ninja as the default build tool for C++ projects, within either you '.bash_profile' or '.bashrc'.
      local codelldb_path = language_configuration_utility.get_mason_package_path("codelldb")
      dap.adapters.codelldb = {
        type = "executable",
        command = codelldb_path .. "\\extension\\adapter\\codelldb", -- IMPORTANT: Absolute Path to Codelldb.exe: "/absolute/path/to/codelldb".
        -- NOTE: On windows you may have to uncomment this:
        detached = false,
      }

      dap.configurations.cpp = {
        {
          type = "codelldb",
          request = "launch",
          name = "Launch file",
          program = function()
            -- Get the current file's directory
            local current_dir = vim.fn.expand("%:p:h:h")
            -- Build the expected path to the bin directory
            local bin_dir = current_dir .. "/bin"
            -- Find all .exe files in the bin directory
            local executable = vim.fn.glob(bin_dir .. "/*.exe")
            -- Check if we found any executables
            return executable
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      -- INFO: C# DEBUG ADAPTER CONFIG:
      local netcoredbg_path = language_configuration_utility.get_mason_package_path("netcoredbg")
      dap.adapters.coreclr = {
        type = "executable",
        command = netcoredbg_path .. "\\netcoredbg\\netcoredbg",
        args = { "--interpreter=vscode" },
        options = {
          detached = false, -- IMPORTANT: Specific to windows in the case of C#, we don't want other terminals opening up outside of the neovim session / the console you're using.
        },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            -- Get the current cs project file's directory.
            local current_dir = vim.fn.expand("%:p:h")
            -- Starting from the current directory, move up until we find the .csproj file.
            while current_dir ~= "/" do
              local csproj = vim.fn.glob(current_dir .. "/*.csproj")
              if csproj ~= "" then -- If not in the current directory. MOVE UP ONE DIRECTORY.
                -- Found the project directory, now extract project name, to find corresponding '.dll' file.
                local project_name = vim.fn.fnamemodify(csproj, ":t:r")
                local debug_dir = current_dir ..
                    "/bin/Debug/net8.0" -- WARN: .NET8.0 is just the runtime currently being used, by me. Change if you are using a different runtime.
                local dll_path = debug_dir .. "/" .. project_name .. ".dll"

                -- Checking if the '.dll' file exists, then returning it. (It's the compiled code containing the 'Debug symbols' required by the debugger)
                if vim.fn.filereadable(dll_path) == 1 then
                  return dll_path
                end
              end
              -- MOVING UP ONE DIRECTORY.
              current_dir = vim.fn.fnamemodify(current_dir, ":h")
            end
            -- If no compiled project could be found (.dll file), just message the user.
            print("There is no valid c_sharp project present.")
          end,
        },
      }

      -- INFO: Python DEBUG ADAPTER CONFIG:
      local debugpy_path = language_configuration_utility.get_mason_package_path("debugpy")
      dap.adapters.python = {
        type = "executable",
        command = debugpy_path .. "/venv/bin/python", -- NOTE: "debugpy" is actually a plugin for python. It comes packaged within a python virtual environment.
        args = { "-m", "debugpy.adapter" },           -- So, we are using the version of python installed within the adapter's virtual environment.
        options = {
          detached = false,                           -- IMPORTANT: Specific to windows in the case of Python, we don't want other terminals opening up
        },                                            -- outside of the neovim session / the console you're using.
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function() -- NOTE: Here we are actually using the version of python installed by mason for debugpy.
            return debugpy_path .. "/venv/bin/python"
          end,
        },
      }

      -- INFO: JavaScript & TypeScript DEBUG ADAPTER CONFIG:
      local vscode_javascript_debug_path = language_configuration_utility.get_mason_package_path(
        "js-debug-adapter") -- NOTE: Also know as "vscode-javascript-debug".
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { vscode_javascript_debug_path .. "/js-debug/src/dapDebugServer.js", "${port}" },
        },
      }

      dap.configurations.javascript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal", -- IMPORTANT: Preventing the node debug adapter from startin in an external prompt.
        },
      }
      -- IMPORTANT: TypeScript REQUIRES the 'ts-node' plugin installed globally
      -- or locally in a node project, then create a typescript config with 'npx tsc --init'.
      dap.configurations.typescript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          runtimeExecutable = "ts-node",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
        },
      }



      -- SECTION: 8. Setting up the Debug Adapter UI & Listeners for a better debug expierence.
      -- PLUGIN: The 'nvim-dap-ui' plugin provides a user interface for the nvim-dap debugging framework,
      -- offering visual elements like scopes, breakpoints, stacks, and watches within Neovim.
      local dapui = require("dapui")
      dapui.setup() -- OOO: Initialising UI.
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end



      -- SECTION: 9. Setting nice icons for debug breakpoints, and Dap Virtual Text for nice debugging variable value text notes.
      -- PLUGIN: The 'nvim-dap-virtual-text' plugin displays variable values and execution context as virtual text inline
      -- with your code during debugging sessions with the 'nvim-dap' plugin.
      vim.fn.sign_define(
        "DapBreakpoint",
        { text = "●", texthl = "", linehl = "debugBreakpoint", numhl = "debugBreakpoint" }
      )
      require("nvim-dap-virtual-text").setup {
        enabled = true,                     -- enable this plugin (the default)
        enable_commands = true,
        enabled_commands = true,            -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
        highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_new_as_changed = false,   -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
        show_stop_reason = true,            -- show stop reason when stopped for exceptions
        commented = false,                  -- prefix virtual text with comment string
        only_first_definition = true,       -- only show virtual text at first definition (if there are multiple)
        all_references = false,             -- show virtual text on all all references of the variable (not only definitions)
        virt_lines_above = true,
        filter_references_pattern = '<module',
        text_prefix = '',
        error_prefix = '   ',
        info_prefix = '   ',
        separator = ',',
        clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
        --- A callback that determines how a variable is displayed or whether it should be omitted
        --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
        --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
        --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
        display_callback = function(variable, _, _, _, options)
          -- by default, strip out new line characters
          if options.virt_text_pos == 'inline' then
            return ' = ' .. variable.value:gsub("%s+", " ")
          else
            return variable.name .. ' = ' .. variable.value:gsub("%s+", " ")
          end
        end,
        -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
        virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

        -- experimental features:
        all_frames = false,     -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        virt_lines = false,     -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = nil -- position the virtual text at a fixed window column (starting from the first text column) ,
        -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
      }



      -- SECTION: 10. Registering 'which-key' keymaps for the Debug Adapter(s), Debug Adapter UI, and Mason Package Manager.
      -- IMPORTANT: Define keymaps to be registered with 'which-key' using ONLY 'vim.keymap.set'. (ITS THE STANDARD)
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
        { desc = "Toggle Conditioned Breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Start/Continue Debugging" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<leader>dp", dap.pause, { desc = "Pause" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last Debug Session" })
      vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step Out" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
      vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
      vim.keymap.set("n", "<leader>de", dapui.eval, { desc = "Evaluate Expression" })
      vim.keymap.set("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })
    end,
  },
}
