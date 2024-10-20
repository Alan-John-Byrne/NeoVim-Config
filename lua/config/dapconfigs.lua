local dap = require("dap") -- WARN: REQUIRED FOR ALL LANGUAGE SETUPS.

-- TODO: C++ DEBUG ADAPTER CONFIGURATION:
dap.adapters.cppdbg = { -- NOTE: HERE WE ARE CREATING A DEBUG ADAPTER 'TYPE' WE WILL USE BELOW WITHIN A CONFIGURATION.
  id = "cppdbg",
  type = "executable", -- Because we are using the debugger's executable program.
  -- IMPORTANT: The actual path to the cpp OpenDebugAD7 debugger.
  command = "C:\\Users\\alanj\\.vscode\\extensions\\ms-vscode.cpptools-1.22.9-win32-x64\\debugAdapters\\bin\\OpenDebugAD7.exe",
  options = {
    detached = false,
  },
}
-- IMPORTANT: MUST DO "g++ -g -o main *yourcppfile*.cpp" when building project.
-- WARN: The '-g' flag is super important, it provides the symbols for the debugger. '-o' will output an executable called 'main.exe'.

dap.configurations.cpp = {
  {
    -- NOTE: Debug Adapter Common Options:
    name = "Launch file",
    type = "cppdbg", -- This is the kind of adapter we will be using for this configuration.
    request = "launch", -- Meaning we wish to 'launch' the debugger.
    -- NOTE: Debug Adapter Specific Options: (ie: Named options would be different for Java compared to C++)
    -- The file / thing we want to debug. NOTE: THIS COULD BE A FUNCTION.
    program = function()
      -- 'expand' returns the path of the current file in the buffer, given a wildcard.
      local current_file = vim.fn.expand("%:p")
      -- 'fnamemodify' returns just the section of a file specified, given a wildcard. NOTE: We're selecting the extension portion.
      local file_extension = vim.fn.fnamemodify(current_file, ":e")
      -- If we're currently looking at a cpp file, then proceed.
      if file_extension == "cpp" then
        -- 'fnamemodify' returns the root (filename without extension) of file, then we concatenate '.exe'.
        local executable = vim.fn.fnamemodify(current_file, ":r") .. ".exe"
        -- Check if the executable file exists, if it does, this is file we execute the debugger on.
        if vim.fn.filereadable(executable) == 1 then
          return executable
        end
      end
      -- IMPORTANT: Fall back to user input if we couldn't determine the executable
    end,
    cwd = "${workspaceFolder}", -- Setting the working directory of the application being ran by the C++ debugger. IMPORTANT: REQUIRED.
    stopOnEntry = true,
  },
}

-- TODO: Java DEBUG ADAPTER CONFIGURATION:
-- WARN: HANDLED BY THE NVIM-JDTLS PLUGINHANDLED BY THE NVIM-JDTLS PLUGIN.

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
