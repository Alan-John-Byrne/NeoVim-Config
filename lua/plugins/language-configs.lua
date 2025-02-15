-- XXX: PROGRAMMING LANGUAGE CONFIGURATIONS:
-- PLUGIN:(S) 'nvim-lspconfig', 'mason.nvim', 'mason-lspconfig', 'mason-null-ls', 'mason-nvim-dap.nvim', 'nvim-treesitter' & 'plenary.nvim', 'nvim-nio', 'none-ls.nvim', 'nvim-dap-ui'.
-- ALL WORK TOGETHER to provide multiple programming language support including features like 'hover descriptions', 'debugging support' and 'better text highlighting'.
-- WARN: See below for how everything works together.
return {
  "neovim/nvim-lspconfig", -- Handles LSP configuration.
  enabled = true,          -- TESTING
  dependencies = {
    -- TODO: Package Management
    "williamboman/mason.nvim",           -- Mason (LSP, DAP, Linters, Formatters).
    "williamboman/mason-lspconfig.nvim", -- Mason <-> LSP bridge.
    "jay-babu/mason-null-ls.nvim",       -- Mason <-> null-ls bridge (Linters & Formatters).
    "jay-babu/mason-nvim-dap.nvim",      -- Mason <-> DAP bridge (Debug Adapters).
    "nvim-treesitter/nvim-treesitter",   -- Tree-sitter integration. (Syntax Highlighting)

    -- TODO: Core Plugins
    "nvim-lua/plenary.nvim",  -- Required for various plugins.
    "nvim-neotest/nvim-nio",  -- Required for nvim-dap-ui.
    "nvimtools/none-ls.nvim", -- null-ls (Linters & Formatters).
    "mfussenegger/nvim-dap",  -- DAP (Debug Adapter Protocol).
    "rcarriga/nvim-dap-ui",   -- Debugging UI for nvim-dap.
  },
  config = function()
    --  TODO: 1. Setup Mason (UI-Based Package Manager)
    require("mason").setup()

    -- TODO: 2. Setup LSPs (Auto-Install + Auto-Config)
    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "pyright", "vtsls", "clangd" }, -- Auto-install these LSPs
      automatic_installation = true,                                 -- Makes installed LSPs work instantly
    })

    -- Auto-configure installed LSPs
    local lspconfig = require("lspconfig")
    require("mason-lspconfig").setup_handlers({
      function(server_name)
        lspconfig[server_name].setup({})
      end,
    })

    -- TODO: 3. Setup Linters & Formatters (null-ls)
    require("mason-null-ls").setup({
      ensure_installed = { "stylua", "selene" }, -- Auto-install these Linters / Formatters.
      automatic_installation = true,             -- NOTE: Enables them automatically
    })

    --    IMPORTANT: 'mason-null-ls' ALLOWS FOR AVOIDING MANUAL CONFIGURATIONS LIKE BELOW.
    --    local null_ls = require("null-ls")
    --    null_ls.setup({
    --      sources = {
    --        -- 🔹 Formatters
    --        null_ls.builtins.formatting.stylua, -- Lua Formatter
    --        -- 🔹 Linters
    --        null_ls.builtins.diagnostics.selene, -- Lua Linter
    --      },
    --    })

    -- TODO: 4 Setup Debug Adapters (DAP)
    require("mason-nvim-dap").setup({
      ensure_installed = { "python", "codelldb", "js-debug-adapter" }, -- Auto-install these DAPs.
    })

    -- IMPORTANT: MANUAL DAP CONFIGURATIONS ARE STILL REQUIRED FOR ALL LANGUAGES. (Except for Java)
    local dap = require("dap")
    local my_functions = require("my_functions")

    -- TODO: Java DEBUG ADAPTER CONFIGURATION:
    -- WARN: HANDLED BY THE NVIM-JDTLS PLUGIN.

    -- WARN: C++ DEBUG ADAPTER CONFIGURATION:
    -- IMPORTANT: MUST DO "g++ -g -o main *yourcppfile*.cpp" when building project. (If only compiling and debugging a single file.)
    -- WARN: The '-g' flag is super important, it provides the symbols for the debugger. '-o' will output an executable called 'main.exe'.
    -- REMEMBER: The 'Ninja' build tools must be installed on your system (set as default build tools for C++ projects) and entered into your system environment variables. It's Required for clangd lsp.
    local codelldb_path = my_functions.get_mason_package_path("codelldb")
    dap.adapters.codelldb = {
      type = 'executable',
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

    -- WARN: Python DEBUG ADAPTER CONFIGURATION:
    -- Get debugpy path
    local debugpy_path = my_functions.get_mason_package_path("debugpy")
    -- Python adapter setup
    dap.adapters.python = {
      type = "executable",
      command = debugpy_path .. "/venv/Scripts/python", -- NOTE: Using the packages version of python installed via it's virtual environment.
      args = { "-m", "debugpy.adapter" },               -- NOTE: "debugpy" is actually a plugin for python, which is preferrably installed within a virtual environment.
      options = {
        detached = false,                               -- IMPORTANT: Specific to windows in the case of python, we don't want other terminals opening up outside of the neovim session / powershell.
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

    -- WARN: JavaScript DEBUG ADAPTER CONFIGURATION:
    -- Get 'js-debug-adapter' path - (vscode-javascript-debug)
    local vscode_javascript_debug_path = my_functions.get_mason_package_path("js-debug-adapter")
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        -- 💀 Make sure to update this path to point to your installation
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

    -- TODO: 5. Setting up the Debug Adapter UI & Listeners for a better debug expierence.
    local dapui = require("dapui")
    dapui.setup() -- Initialising UI.

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
    vim.fn.sign_define('DapBreakpoint',
      { text = '●', texthl = '', linehl = 'debugBreakpoint', numhl = 'debugBreakpoint' })

    -- TODO: 7. Registering keymaps for the Debug Adapter(s), Debug Adapter UI, and Mason Package Manager.
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

    -- TODO: 8. Setup Tree-sitter (Language Parsing)
    local treesitter = require("nvim-treesitter.configs")
    treesitter.setup({
      ensure_installed = { "lua", "python", "javascript", "cpp", "java", "c_sharp" }, -- Specify languages you want Tree-sitter for
      highlight = {
        enable = true,                                                                -- Enable highlighting based on Tree-sitter
        additional_vim_regex_highlighting = false,                                    -- Disable regex highlighting (Tree-sitter will handle this)
      },
      indent = {
        enable = true, -- Enable Tree-sitter-based indentation
      },
    })
  end,
}
