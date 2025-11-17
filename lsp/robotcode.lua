-- IMPORTANT: WE *MUST* RETURN AN EMPTY TABLE IF REQUIREMENTS ARE NOT SATISFIED!
-- If as just 'return ...' and then nothing, *it will crash neovim*.
-- LSP: robotcode
-- CONFIGURATION:
local robotcode_configuration = function()
  -- OOO: 1: First check if we're currently in a python virtual environment.
  local current_python_env = nil
  if require("venv-selector").venv() then
    current_python_env = require("venv-selector").venv() .. "/python"
  else
    -- PART: We're NOT located in a virtual environment.
    return {}
  end

  if current_python_env then
    -- PART: We're located in a virtual environment.
    -- OOO: 2: Then store all the python packages currently in that environment.
    local freeze = vim.fn.system({ current_python_env, "-m", "pip", "freeze" })
    -- OOO: 3: Check if the required packages are within the python environment already.
    -- NOTE: '%' is the lua equavalent of '\' in bach. It's the escape character. '-' is a special lua pattern.
    local target_pkgs = { "robotcode", "robotcode%-language%-server" }
    local found = 0
    for _, target in ipairs(target_pkgs) do
      -- INFO: gmatch(freeze, "[^\r\n]+") -> “Match a continuous group of characters,
      -- where each character is not \r or \n”, the 'line'.
      for line in string.gmatch(freeze, "[^\r\n]+") do
        if line:match("^" .. target .. "==") then
          found = found + 1
          break
        end
      end
    end
    -- OOO: 4: If the required robot & robotcode packages / libraries are found to be installed
    -- within this virtual environment, then configure and activate the LSP.
    if found == #target_pkgs then
      -- PART: The required pip packages ARE installed within the virtual environment.
      -- WARN: We must use the LSP binary provided by the robotcode package installed WITHIN that
      -- python virtual environment. This gives context to the lsp, about the various pip packages /
      -- libraries installed. Otherwise, we'll get loads of linting errors being thrown within the robot code.
      local robotcode_path = vim.fn.fnamemodify(current_python_env, ':h') .. '/robotcode'
      return {
        cmd = { robotcode_path, "language-server" },
        filetypes = { "robot", "resource" },
      }
    else
      -- PART: The required pip packages are NOT installed within the virtual environment.
      vim.notify("Some required robot packages are missing.", vim.log.levels.ERROR)
      return {}
    end
  else
    vim.notify("No Python interpreter selected through whichpy.", vim.log.levels.ERROR)
    return {}
  end
  -- PART: We're NOT located in a virtual environment.
end

-- OOO: Applying custom configuration.
vim.lsp.config('robotcode', robotcode_configuration())
