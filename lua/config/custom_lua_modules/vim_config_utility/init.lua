--- IMPORTANT: Modules (classes / tables) and their functions use
--- an annotation called 'LuaCats', look it up (it's different from
--- 'EmmyLua'). Module full of random convenience functions.
-- WARN: LuaCat class and method 'descriptions' do NOT work correctly,
-- when adding to the global 'vim' module.
-- DON'T 'MONKEY PATCH' like this -> vim.method_name = function()!!!!
-- TODO: Do this instead -> vim.custom_module = M (i.e.: 'M' being the name of your module)
-- INFO: Custom Vim Configuration Utility Module.

-- Custom VIMUtility Module.
---@class VimConfigUtility
local M = {}

-- SECTION: Managing Open Buffers Gracefully.

--- Specific function for preventing the snacks.nvim
--- terminal from being closed in an incorrect manner.
function M.protect_snacks_terminal(vimcmd)
  if vim.bo.buftype == "terminal" then
    vim.notify("You cannot close a Snacks-Terminal buffer like this.\nType 'exit' which will stop the process properly",
      vim.log.levels.WARN)
  else
    if vim.fn.bufnr('#') ~= -1 then
      vim.cmd(vimcmd)
    else
      vim.notify("You can't close this buffer, it's the only one left open.\nThere's no alternate buffer to switch to.",
        vim.log.levels.WARN)
    end
  end
end

--- Prevents certain vim buffer commands from being
--- ran on buffers when switching between then.
---@param vimcmd string The vim command to execute
function M.buffer_protection(vimcmd)
  return function()
    -- PART: For 'e #' command, check if alternate buffer exists.
    if vimcmd == "e #" then
      if vim.fn.bufnr('#') ~= -1 then
        vim.cmd(vimcmd)
      else
        vim.notify(
          "You can't close this buffer, it's the only one left open.\nThere's no alternate buffer to switch to.",
          vim.log.levels.INFO)
      end
      -- PART: For 'bd' command, ensure we're NOT in a 'snacks.nvim' terminal.
    elseif vimcmd == "bd" then
      M.protect_snacks_terminal(vimcmd)
    else
      -- PART: For any other commands, just run them.
      vim.notify("No protection necessary, using 'buffer_protection' method is redundant.", vim.log.levels.WARN)
      vim.cmd(vimcmd)
    end
  end
end

-- SECTION: ...

return M
