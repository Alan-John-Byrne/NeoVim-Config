-- LSP:
-- CONFIGURATION:
-- OOO: 1: First check if we're currently in a python virtual environment.
local current_python_env = require("whichpy.envs").current_selected()
if current_python_env then
  -- OOO: 2: Then store all the python packages currently in that environment.
  local freeze = vim.fn.system({ current_python_env, "-m", "pip", "freeze" })
  -- OOO: 3: Check if the required packages are within the python environment already.
  -- NOTE: '%' is the lua equavalent of '\' in back, it's the escape character. '-' is a special lua pattern.
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
    -- IMPORTANT: We must use the LSP binary provided by the robotcode package installed WITHIN that
    -- python virtual environment. This gives context to the lsp, about the various libraries installed.
    local robotcode_path = vim.fn.fnamemodify(current_python_env, ':h') .. '/robotcode'
    vim.lsp.config('robotcode', {
      cmd = { robotcode_path, "language-server" },
      filetypes = { "robot", "resource" },
    })
    vim.lsp.enable('robotcode')
  else
    vim.notify("Some required robot packages are missing.", vim.log.levels.ERROR)
  end
else
  vim.notify("No Python interpreter selected through whichpy.", vim.log.levels.ERROR)
end
-- REMEMBER: We have 'mason-lspconfig' which uses the nvim-lspconfig plugins 'protocol' to integrate
-- lsp tools (i.e.: an LSP consisting of linting & formatting capabilities) into neovim for various
-- language support. But this LSP differs in terms of architecture compared to those other LSPs.
