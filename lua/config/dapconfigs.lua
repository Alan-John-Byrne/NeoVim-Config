local dap = require("dap") -- WARN: REQUIRED FOR ALL LANGUAGE SETUPS.

-- TODO: C++ DEBUG ADAPTER CONFIGURATION:
dap.adapters.codelldb = { -- NOTE: HERE WE ARE CREATING A DEBUG ADAPTER 'TYPE' WE WILL USE BELOW WITHIN A CONFIGURATION.
  type = "server",
  port = "${port}",
  executable = {
    -- CHANGE THIS to your path!
    -- IMPORTANT: The actual path to the Cpp Debugger.
    command = "C:\\Users\\alanj\\AppData\\Local\\nvim-data\\mason\\packages\\codelldb\\extension\\adapter\\codelldb.exe",
    args = { "--port", "${port}" },
  },
  options = {
    detached = false,
  },
}

-- IMPORTANT: MUST DO "g++ -g -o main *yourcppfile*.cpp" when building project. (If only compiling and debugging a single file.)
-- WARN: The '-g' flag is super important, it provides the symbols for the debugger. '-o' will output an executable called 'main.exe'.

dap.configurations.cpp = {
  {
    -- NOTE: Debug Adapter Common Options:
    name = "Launch file",
    type = "codelldb", -- This is the kind of adapter we will be using for this configuration.
    request = "launch", -- Meaning we wish to 'launch' the debugger.
    -- NOTE: Debug Adapter Specific Options: (ie: Named options would be different for Java compared to C++)
    program = function()
      -- Get the current file's directory
      local current_dir = vim.fn.expand("%:p:h")
      -- Build the expected path to the bin directory
      local bin_dir = vim.fs.dirname(current_dir) .. "/bin"
      -- Find all .exe files in the bin directory
      local executable = vim.fn.glob(bin_dir .. "/*.exe")
      -- Check if we found any executables
      return executable
    end,
    cwd = vim.fs.dirname(vim.fn.expand("%:p:h")), -- Setting the working directory of the application being ran by the C++ debugger. IMPORTANT: REQUIRED.
    stopOnEntry = false,
    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "enable pretty printing",
        ignoreFailures = false,
      },
    },
  },
}

-- TODO: Java DEBUG ADAPTER CONFIGURATION:
-- WARN: HANDLED BY THE NVIM-JDTLS PLUGIN.

-- TODO: Python DEBUG ADAPTER CONFIGURATION:
-- Helper function to get the Mason package path
local function get_mason_package_path(package_name)
  local mason_registry = require("mason-registry")
  local package = mason_registry.get_package(package_name)
  return package:get_install_path() -- We need to retrieve the path of where the package is installed, because it will contain everything we need.
end

-- Get debugpy path
local debugpy_path = get_mason_package_path("debugpy")

-- Python adapter setup
dap.adapters.python = {
  type = "executable",
  command = debugpy_path .. "/venv/Scripts/python", -- NOTE: Using the packages version of python installed via it's virtual environment.
  args = { "-m", "debugpy.adapter" }, -- NOTE: "debugpy" is actually a plugin for python, which is preferrably installed within a virtual environment.
  options = {
    detached = false, -- IMPORTANT: Specific to windows, we don't want other terminals opening up outside of the neovim session / powershell.
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
