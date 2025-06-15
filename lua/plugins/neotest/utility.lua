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

--- Checks if the current npm project is using playwright.
---@return boolean true/false
---@nodiscard
function M.is_playwright_project()
  local playwright_filename = "playwright.config.ts"
  -- Getting the current path / directory we are in.
  local path = vim.fn.expand("%:p:h")
  -- Whilst we have a path, AND it's not the 'root' directory.
  while path and path ~= "/" do
    -- Check if there is a 'node_modules' file in the current directory.
    local node_modules = path .. "/node_modules"
    if vim.fn.isdirectory(node_modules) == 1 then
      -- Check if a 'playwright.config.ts' file is also in that same directory.
      local target = path .. "/" .. playwright_filename
      if vim.fn.filereadable(target) == 1 then
        return true -- INFO: This is a playwright project.
      end
    end
    -- NOTE: If npm root is found, we still need the 'playwright.config.ts' file. Move up
    -- to the parent directory if it's not found, and start the same search with the same
    -- criteria again.
    path = vim.fn.fnamemodify(path, ":h")
  end
  -- WARN: npm root never found.
  return false
end

return M
