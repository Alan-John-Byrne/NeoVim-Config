local dap = require("dap")

-- WARN: C++ DEBUG ADAPTER CONFIGURATION:
dap.adapters.cppdbg = { -- NOTE: HERE WE ARE CREATING A DEBUG ADAPTER 'TYPE' WE WILL USE BELOW WITHIN A CONFIGURATION.
  id = "cppdbg",
  type = "executable", -- Because we are using the debugger's executable program.
  -- IMPORTANT: The actual path to the cpp OpenDebugAD7 debugger.
  command = "C:\\Users\\alanj\\.vscode\\extensions\\ms-vscode.cpptools-1.21.6-win32-x64\\debugAdapters\\bin\\OpenDebugAD7.exe",
  options = {
    detached = false,
  },
}

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
  },
}

-- WARN: Java DEBUG ADAPTER CONFIGURATION:
-- NOTE: WORK IN PROGRESS.
