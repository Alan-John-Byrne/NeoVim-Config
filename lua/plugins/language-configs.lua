-- XXX: PROGRAMMING LANGUAGE CONFIGURATIONS:
-- PLUGIN:(S) 'nvim-lspconfig', 'mason.nvim', 'mason-lspconfig', 'mason-null-ls', 'mason-nvim-dap.nvim', 'nvim-treesitter' & 'plenary.nvim', 'nvim-nio', 'none-ls.nvim', 'nvim-dap-ui'.
-- ALL WORK TOGETHER to provide multiple programming language support including features like 'hover descriptions', 'debugging support' and 'better text highlighting'.
-- WARN: See below for how everything works together.
return {
  "neovim/nvim-lspconfig", -- Handles LSP configuration.
  enabled = true, -- TESTING
  dependencies = {
    -- TODO: Package Management
    "williamboman/mason.nvim", -- Mason (LSP, DAP, Linters, Formatters).
    "williamboman/mason-lspconfig.nvim", -- Mason <-> LSP bridge.
    "jay-babu/mason-null-ls.nvim", -- Mason <-> null-ls bridge (Linters & Formatters).
    "jay-babu/mason-nvim-dap.nvim", -- Mason <-> DAP bridge (Debug Adapters).
    "nvim-treesitter/nvim-treesitter", -- Tree-sitter integration. (Syntax Highlighting)
    "theHamsta/nvim-dap-virtual-text", -- Provides nice variable text when debugging.

    -- TODO: Core Plugins
    "nvim-lua/plenary.nvim", -- Required for various plugins.
    "nvim-neotest/nvim-nio", -- Required for nvim-dap-ui.
    "nvimtools/none-ls.nvim", -- null-ls (Linters & Formatters).
    "mfussenegger/nvim-dap", -- DAP (Debug Adapter Protocol).
    "rcarriga/nvim-dap-ui", -- Debugging UI for nvim-dap.
    "jbyuki/one-small-step-for-vimkind", -- WARN: Debug adapter for 'lua' not provided by Mason package manager!
  },
  config = function()
    --  TODO: 1. Setup Mason (UI-Based Package Manager), and Dap Virtual Text (Provides nice debugging variable value text notes.)
    require("mason").setup()
    require("nvim-dap-virtual-text").setup()

    -- TODO: 2. Setup LSPs (Auto-Install + Auto-Config)
    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "pyright", "vtsls", "clangd", "marksman" }, -- Auto-install these LSPs
      automatic_installation = true,
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
      ensure_installed = { "stylua", "selene", "markdownlint", "prettierd" }, -- Auto-install these Linters / Formatters.
      automatic_installation = true,
    })

    --  NOTE: 'mason-null-ls' allows us to then manually configure linters and formatters,
    --  if they're not already included within their LSPs.
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        -- Linters
        null_ls.builtins.diagnostics.selene, -- Lua Linter
        null_ls.builtins.diagnostics.markdownlint, -- Markdown Linter

        -- Formatters
        null_ls.builtins.formatting.stylua, -- Lua Formatter
        null_ls.builtins.formatting.markdownlint, -- Markdown Formatter

        -- WARN: Some function as both linters and formatters. (eg: markdownlint)
      },
    })

    -- TODO: 4 Setup Debug Adapters (DAP)
    require("mason-nvim-dap").setup({
      ensure_installed = { "python", "codelldb", "js-debug-adapter" }, -- Auto-install these DAPs.
      automatic_installation = true,
    })

    --  NOTE: 'mason-nvim-dap' allows us to then manually configure debug adapters & configurations for different languages.
    local dap = require("dap")
    local my_functions = require("my_functions")

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
              local debug_dir = current_dir .. "/bin/Debug/net8.0" --WARN: .NET8.0 is just the runtime currently being used, by me. Change if you are using a different runtime.
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
      args = { "-m", "debugpy.adapter" }, -- NOTE: "debugpy" is actually a plugin for python, which is preferrably installed within a virtual environment.
      options = {
        detached = false, -- IMPORTANT: Specific to windows in the case of Python, we don't want other terminals opening up outside of the neovim session / the console you're using.
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

    dap.configurations.typescript = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        runtimeExecutable = "ts-node",
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
    vim.fn.sign_define(
      "DapBreakpoint",
      { text = "●", texthl = "", linehl = "debugBreakpoint", numhl = "debugBreakpoint" }
    )

    -- TODO: 7. Registering keymaps for the Debug Adapter(s), Debug Adapter UI, and Mason Package Manager.
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

    -- TODO: 8. Setup Tree-sitter (Language Parsing)
    local treesitter = require("nvim-treesitter.configs")
    treesitter.setup({
      ensure_installed = { "lua", "python", "javascript", "typescript", "tsx", "cpp", "java", "c_sharp", "markdown" }, -- Specify languages you want Tree-sitter for
      highlight = {
        enable = true, -- Enable highlighting based on Tree-sitter
        additional_vim_regex_highlighting = false, -- Disable regex highlighting (Tree-sitter will handle this)
      },
      indent = {
        enable = true, -- Enable Tree-sitter-based indentation
      },
    })
  end,
}
