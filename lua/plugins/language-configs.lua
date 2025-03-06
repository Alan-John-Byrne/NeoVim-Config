-- XXX: PROGRAMMING LANGUAGE CONFIGURATIONS:
-- PLUGIN:(S) ALL WORK TOGETHER to provide multiple programming language support including features like
-- 'hover descriptions', 'debugging support', 'better text highlighting', 'Linting' and 'Formatting'.
-- WARN: See below for how everything works together.
return {
  "neovim/nvim-lspconfig", -- Handles LSP configuration.
  event = "VeryLazy",      -- NOTE: 'VeryLazy' only loads the plugin when needed (On powershell files).
  -- IMPORTANT: 'VeryLazy' allows package managers (e.g.: lazy.nvim, Mason, etc...) to load the plugin ahead of time,
  -- so we can request them later within another plugins config functions. Otherwise we get errors saying a plugin 'doesn't
  -- exist', cause we create a race condition saying we need it to load the plugin before even it's package manager has a chance to load.
  enabled = true, -- TESTING
  dependencies = {
    -- TODO: Package / Plugin Management:
    "williamboman/mason.nvim",           -- Mason (LSP, DAP, Linters, Formatters).
    "williamboman/mason-lspconfig.nvim", -- Mason <-> nvim-lspconfig (LSP) bridge.
    "jay-babu/mason-nvim-dap.nvim",      -- Mason <-> nvim-dap bridge (Debug Adapter Protocols / DAPs).
    "rshkarin/mason-nvim-lint",          -- Mason <-> nvim-lint bridge (Linters).
    "zapling/mason-conform.nvim",        -- Mason <-> conform bridge (Formatters).
    "nvim-treesitter/nvim-treesitter",   -- Tree-sitter integration. (Syntax Highlighting)

    -- TODO: Core Plugins:
    "nvim-lua/plenary.nvim",  -- Required for various plugins.
    "nvim-neotest/nvim-nio",  -- Required for nvim-dap-ui.
    "mfussenegger/nvim-lint", -- nvim-lint (Linters).
    "stevearc/conform.nvim",  -- conform (Formatters).
    "mfussenegger/nvim-dap",  -- nvim-dap (Debug Adapter Protocols / DAPs).
    "rcarriga/nvim-dap-ui",   -- Debugging UI for nvim-dap.

    -- XXX: Other Plugins:
    "L3MON4D3/LuaSnip",                  -- LuaSnip (Loads snippets from VSCode).
    "hrsh7th/nvim-cmp",                  -- nvim-cmp (Auto-Completion).
    "hrsh7th/cmp-nvim-lsp",              -- LSP source for nvim-cmp.
    "saadparwaiz1/cmp_luasnip",          -- Snippet source for nvim-cmp
    "theHamsta/nvim-dap-virtual-text",   -- Provides nice variable text when debugging.
    "jbyuki/one-small-step-for-vimkind", -- Debug adapter for 'lua' not provided by Mason package manager!
    "leoluz/nvim-dap-go",                -- Debug adapter for 'go' / 'golang' not provided by Mason package manager!
  },
  config = function()
    --  TODO: 1. Setup Mason (UI-Based Package Manager), and Dap Virtual Text (Provides nice debugging variable value text notes.)
    -- IMPORTANT: Ensure "...\nvim-data\mason\bin" directory is accessible via the PATH.
    -- This is how bridge plugins can access the plugins you install via the Mason UI, setup
    -- immediately below.
    require("mason").setup()
    require("nvim-dap-virtual-text").setup()

    -- TODO: 2. Setup LSPs (Auto-Install + Auto-Config)
    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "pyright", "vtsls", "clangd", "powershell_es" }, -- Auto-install these LSPs
      automatic_installation = true,
    })

    -- NOTE: Setting up all installed LSPs.
    local lspconfig = require("lspconfig")
    require("mason-lspconfig").setup_handlers({
      function(server_name)
        lspconfig[server_name].setup({}) -- XXX: Just use default settings for all other LSPs.
      end,
    })

    -- TODO: 3. Setup Linters & Formatters:
    -- NOTE: 'mason-nvim-lint' & 'mason-conform allows us to then manually configure Linters and Formatters, respectively.
    -- WARN: Some function as both linters and formatters. (eg: markdownlint)
    -- REMEMBER: Linters & formatters ONLY kick into action when you save a buffer. (So we use autocommands)
    -- XXX: Linters:
    require("mason-nvim-lint").setup({
      ensure_installed = { "selene", "markdownlint" }, -- Auto-install these Linters.
      automatic_installation = true,
    })

    require("lint").linters_by_ft = { -- Hook these Linters into Neovim.
      markdown = { "markdownlint" },
      lua = { "selene" },
    }

    -- Autocommand to trigger linter automatically.
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
      pattern = { "*.lua", "*.md" },
      callback = function()
        require("lint").try_lint()
      end,
    })

    -- XXX: Linters (continued): Setting linter specific settings via args table.
    require("lint").linters.markdownlint.args = {
      "--disable",
      "MD013",
      "MD026",
      "MD041",
      "MD033",
    }

    -- XXX: Formatters:
    require("mason-conform").setup({
      ensure_installed = { "prettier" }, -- Auto-install these Formatters.
      automatic_installation = true,
    })

    require("conform").setup({ -- Hook these Formatters into Neovim.
      formatters_by_ft = {
        markdown = { "prettier" },
        go = { "goimports" }
      },
    })

    -- Autocommand to trigger formatter automatically on buffer content save.
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*", -- This applies to all files, you can change the pattern to a specific file type (e.g. "*.lua" or "*.md" etc)
      callback = function()
        -- REMEMBER: USE 'Lua_ls' LSP for better formatting.
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.buf_get_clients(bufnr)
        local lua_is_active = false
        for index, client in ipairs(clients) do
          if client.name == "lua_ls" then
            lua_is_active = true
          end
        end
        if lua_is_active then
          vim.lsp.buf.format({ async = false }) -- Format using 'lua_ls' LSP. IMPORTANT: Must NOT be ASYNCHRONOUS, must FORMAT AFTER SAVING CONTENTS to buffer.
        else
          require("conform").format()           -- This Triggers conform based formatters.
        end
      end,
    })

    -- TODO: 4 Setup Debug Adapters (DAP)
    require("mason-nvim-dap").setup({
      ensure_installed = { "python", "codelldb", "js-debug-adapter" }, -- Auto-install these DAPs.
      automatic_installation = true,
    })

    --  NOTE: 'mason-nvim-dap' allows us to then manually configure debug adapters & configurations for different languages.
    local dap = require("dap")
    local my_functions = require("my_functions")

    -- WARN: GOLANG DEBUG ADAPTER CONFIGURATION:
    local dap_go = require("dap-go")

    dap_go.setup()
    -- WARN: Java DEBUG ADAPTER CONFIGURATION:
    -- IMPORTANT: HANDLED BY THE NVIM-JDTLS PLUGIN.

    -- WARN: LUA DEBUG ADAPTER CONFIGURATION:
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

    -- WARN: C++ DEBUG ADAPTER CONFIGURATION:
    -- IMPORTANT: MUST DO "g++ -g -o main *yourcppfile*.cpp" when building project. (If only compiling and debugging a single file.)
    -- WARN: The '-g' flag is super important, it provides the symbols for the debugger. '-o' will output an executable called 'main.exe'.
    -- REMEMBER: The 'Ninja' build tools must be installed on your system (set as default build tools for C++ projects) and entered into your system environment variables. It's Required for clangd lsp.
    local codelldb_path = my_functions.get_mason_package_path("codelldb")
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

    -- WARN: C# DEBUG ADAPTER CONFIGURATION:
    local netcoredbg_path = my_functions.get_mason_package_path("netcoredbg")
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

    -- WARN: Python DEBUG ADAPTER CONFIGURATION:
    -- Get debugpy path
    local debugpy_path = my_functions.get_mason_package_path("debugpy")
    -- Python adapter setup
    dap.adapters.python = {
      type = "executable",
      command = debugpy_path .. "/venv/Scripts/python", -- NOTE: Using the packages version of python installed via it's virtual environment.
      args = { "-m", "debugpy.adapter" },               -- NOTE: "debugpy" is actually a plugin for python, which is preferrably installed within a virtual environment.
      options = {
        detached = false,                               -- IMPORTANT: Specific to windows in the case of Python, we don't want other terminals opening up outside of the neovim session / the console you're using.
      },
    }
    -- Python configuration
    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = function() -- NOTE: Here we are actually using the version of python installed by mason for debugpy.
          return debugpy_path .. "/venv/Scripts/python"
        end,
      },
    }

    -- WARN: JavaScript & TypeScript DEBUG ADAPTER CONFIGURATION:
    -- Get 'js-debug-adapter' path - (vscode-javascript-debug)
    local vscode_javascript_debug_path = my_functions.get_mason_package_path("js-debug-adapter")
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

    -- TODO: 5. Setting up the Debug Adapter UI & Listeners for a better debug expierence.
    local dapui = require("dapui")
    dapui.setup() -- XXX: Initialising UI.
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

    -- TODO: 6. Setting nice icons for debug breakpoints.
    vim.fn.sign_define(
      "DapBreakpoint",
      { text = "●", texthl = "", linehl = "debugBreakpoint", numhl = "debugBreakpoint" }
    )

    -- TODO: 7. Setup Tree-sitter (Language Parsing)
    local treesitter = require("nvim-treesitter.configs")
    treesitter.setup({
      ensure_installed = {
        "lua",
        "python",
        "javascript",
        "typescript",
        "tsx",
        "cpp",
        "java",
        "c_sharp",
        "markdown",
        "go",
        "powershell",
      },                                           -- Specify languages you want Tree-sitter for
      highlight = {
        enable = true,                             -- Enable highlighting based on Tree-sitter
        additional_vim_regex_highlighting = false, -- Disable regex highlighting (Tree-sitter will handle this)
      },
      indent = {
        enable = true, -- Enable Tree-sitter-based indentation
      },
    })

    -- TODO: 8. Setting up Auto-Completions.
    require("luasnip.loaders.from_vscode").lazy_load() -- Lazy-loading in VSCode snippets for faster auto-completion.
    local cmp = require("cmp")
    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body) -- Expanding the snippet using luasnip. So we see a preview.
        end,
      },
      mapping = {
        ["<Tab>"] = cmp.mapping.select_next_item(),        -- Next completion item (Tab)
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),      -- Previous completion item (Shift-Tab)
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection (Enter / Carriage Return)
      },
      sources = {
        { name = "nvim_lsp" }, -- LSP completions. (DEPENDENCY: cmp-nvim-lsp / LSP source for nvim-cmp)
        { name = "luasnip" },  -- LuaSnip completions (DEPENDENCY: lazy loaded VSCode snippets / Loads snippets from VSCode).
        { name = "buffer" },   -- Buffer completions (NOT DEPENDENCY: words from the current buffer - already there by default).
      },
    })

    -- TODO: 9. Registering which-key keymaps for the Debug Adapter(s), Debug Adapter UI, and Mason Package Manager.
    -- IMPORTANT: Define keymaps to be registered with 'which-key' using ONLY 'vim.keymap.set'. (ITS THE STANDARD)
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Toggle Conditioned Breakpoint" })
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
}
