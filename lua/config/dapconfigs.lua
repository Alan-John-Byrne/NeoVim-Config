local dap = require("dap") -- WARN: REQUIRED FOR ALL LANGUAGE SETUPS.
local my_functions = require("my_functions")

-- TODO: C++ DEBUG ADAPTER CONFIGURATION:
-- IMPORTANT: MUST DO "g++ -g -o main *yourcppfile*.cpp" when building project. (If only compiling and debugging a single file.)
-- WARN: The '-g' flag is super important, it provides the symbols for the debugger. '-o' will output an executable called 'main.exe'.
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
  },
}

-- TODO: Java DEBUG ADAPTER CONFIGURATION:
-- WARN: HANDLED BY THE NVIM-JDTLS PLUGIN.

-- TODO: Python DEBUG ADAPTER CONFIGURATION:
-- Get debugpy path
local debugpy_path = my_functions.get_mason_package_path("debugpy")
-- Python adapter setup
dap.adapters.python = {
  type = "executable",
  command = debugpy_path .. "/venv/Scripts/python", -- NOTE: Using the packages version of python installed via it's virtual environment.
  args = { "-m", "debugpy.adapter" }, -- NOTE: "debugpy" is actually a plugin for python, which is preferrably installed within a virtual environment.
  options = {
    detached = false, -- IMPORTANT: Specific to windows in the case of python, we don't want other terminals opening up outside of the neovim session / powershell.
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

-- TODO: JavaScript DEBUG ADAPTER CONFIGURATION:
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
