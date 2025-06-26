local neotest = require("neotest")
local M = {}

-- ADAPTER: NEOTEST HELPER METHODS:
--- Close Open Summary.
---@return boolean
function M.close_neotest_summary()
  -- NOTE: Every window has an id. For every window, check all of its
  -- open buffers, and check their names.
  -- So, in every window:
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    -- 1st: Get the buffer id / number.
    local buf = vim.api.nvim_win_get_buf(win)
    -- 2nd: Get the buffer name, using the buffer id ( within that window ).
    local buf_name = vim.api.nvim_buf_get_name(buf)
    -- WARN: For certain 'special' buffers, 'nvim_win_get_buf' can sometimes return an empty string.
    -- So double checking using legacy vim api ('bufname').
    if buf_name == "" then
      buf_name = vim.fn.bufname(buf)
    end
    -- 3rd: Check if the buffer name is 'Neotest Summary' or if its filetype is 'neotest-summary'.
    if buf_name:match("Neotest Summary") or vim.bo[buf].filetype == "neotest-summary" then
      -- 4.1 (final): Close that window containing that buffer.
      vim.api.nvim_win_close(win, true) -- close window forcefully
      return true
    end
    -- 4.2 (final): If it's not open, just return false.
    return false
  end
end

--- Close and Re-open the buffer.
---@return nil
function M.close_and_reopen_test_buffer()
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
end

-- ADAPTER: PLAYWRIGHT HELPER METHODS:
--- Refresh playwright data.
---@return nil
function M.refresh_playwright()
  -- IMPORTANT: 1st: Close the neotest summary window if it's open.
  -- Avoids breaking everything, then having to re-open neovim.
  local open = M.close_neotest_summary()
  -- 2nd: Clear previous data:
  local path = vim.fn.stdpath('data') .. '/neotest-playwright.json'
  os.remove(path)
  vim.cmd("NeotestPlaywrightRefresh")
  -- 3rd: Close and reopen the test buffer. (Refreshing data)
  M.close_and_reopen_test_buffer()
  print("Summary refreshed!")
  -- 4th (final): Open back up the neotest summary again, ONLY if it was already open.
  if (open) then
    neotest.summary.toggle()
  end
end

--- Allow the user to selects browsers to run tests for, then refresh summary tree.
---@return nil
function M.select_browsers()
  -- Prompt the user to confirm their project selection. (Refreshing data)
  vim.ui.input({ prompt = "Press 'Enter' AGAIN to confirm project selection." }, function()
    M.refresh_playwright()
    vim.loop.sleep(1000)
    M.close_and_reopen_test_buffer()
  end)
  -- Show confirmation prompt BEFORE selection.
  vim.schedule(function()
    vim.cmd("NeotestPlaywrightProject") -- NOTE: Original broken command.
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
