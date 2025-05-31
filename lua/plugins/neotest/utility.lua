local M = {}

-- ADAPTER: PLAYWRIGHT HELPER METHODS:
--- Refresh playwright data.
---@return nil
function M.refresh_playwright()
  -- 1st: Clear previous data:
  local path = vim.fn.stdpath('data') .. '/neotest-playwright.json'
  os.remove(path)
  -- 2nd: Refresh the summary: (Algorithm to refresh)
  -- Get the current directory where the user entered neovim.
  local current_dir = vim.fn.getcwd()
  -- Get the name of the buffer (the test file) and it's directory.
  local buffer_name = vim.api.nvim_buf_get_name(0)
  local buffer_dir = vim.fn.fnamemodify(buffer_name, ":h")
  -- Delete the test file (buffer).
  vim.api.nvim_buf_delete(0, {})
  -- Open the test file (buffer).
  vim.cmd("cd " .. buffer_dir)
  vim.cmd("edit " .. buffer_name)
  -- Return to original entry where user entered neovim.
  if current_dir ~= buffer_dir then
    vim.cmd("cd " .. current_dir)
  end
  -- 3nd: Refresh the summary: (Algorithm to refresh)
  vim.cmd("NeotestPlaywrightRefresh")
  print("Summary refreshed!")
end

--- Allow the user to selects browsers to run tests for, then refresh summary tree.
---@return nil
function M.select_browsers()
  -- 4th: Ensure project selection screen shows after confirmation prompt.
  vim.schedule(function()
    vim.cmd("NeotestPlaywrightProject") -- NOTE: Original broken command.
  end)
  -- 1st: Store where the user enters neovim.
  local current_dir = vim.fn.getcwd()
  -- 2nd: Get the name (fullpath) of the current buffer and it's directory.
  local buffer_name = vim.api.nvim_buf_get_name(0)
  local buffer_dir = vim.fn.fnamemodify(buffer_name, ":h")
  -- 3rd: Prompt the user to confirm their project selection.
  vim.ui.input({ prompt = "Press 'Enter' AGAIN to confirm project selection." }, function()
    -- After pressing 'Enter' again....
    -- Delete the current buffer (i.e.: The test file the user is currently viewing).
    vim.api.nvim_buf_delete(0, {})
    -- Go to the directory where the buffer is and open it again.
    vim.cmd("cd " .. buffer_dir)
    vim.cmd("edit " .. buffer_name)
    -- Go back to where the user originally entered neovim (if not already there).
    if current_dir ~= buffer_dir then
      vim.cmd("cd " .. current_dir)
    end
  end)
end

--- Checks if an npm project is using the "Playwright" test framework.
---@return boolean true/false
---@nodiscard
function M.is_playwright_project()
  -- Getting the current working directory you were in when you entered neovim.
  local root = vim.fn.getcwd()
  -- Checking if "@playwright/test" package is within the dependencies. If so return true.
  local package_json = root .. "/package.json"
  if vim.fn.filereadable(package_json) == 1 then
    local json = vim.fn.json_decode(vim.fn.readfile(package_json))
    if json and json.devDependencies and json.devDependencies["@playwright/test"] then
      return true
    end
    if json and json.dependencies and json.dependencies["@playwright/test"] then
      return true
    end
  end
  -- "@playwright/test" package not found, return false.
  return false
end

return M
