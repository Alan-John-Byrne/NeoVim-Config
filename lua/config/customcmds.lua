-- INFO: Autocmds are automatically loaded on the VeryLazy event.

-- OOO: Show currently running linters for the current buffer's file type.
vim.api.nvim_create_user_command("LintInfo", function()
  local filetype = vim.bo.filetype
  local linters = require("lint").linters_by_ft[filetype]
  if linters then
    print("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))
  else
    if filetype then
      print("No linters configured for filetype: " .. filetype)
    else
      print("Linters cannot be found for files with no filetype.")
    end
  end
end, {})

-- OOO: Show all paths within the vim runtimepath.
vim.api.nvim_create_user_command("ShowPaths", function()
  local runtimepath = vim.o.rtp
  local runtimepaths = require("my_functions").split(runtimepath, ",")
  for index, path in ipairs(runtimepaths) do
    print("Index " .. index .. " : " .. path)
  end
end, {})

-- OOO: Defining a custom command to capture and display shell output:
vim.api.nvim_create_user_command('S', function(opts)
  local command = opts.args
  local output_lines = {}
  vim.fn.jobstart({ "bash", "-c", command }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then -- INFO: 'data' is a table consiting of the entire output.
        for _, line in ipairs(data) do
          table.insert(output_lines, line)
        end
        -- Send to noice-friendly `vim.notify` once fully captured
        vim.notify(table.concat(output_lines, "\n"), vim.log.levels.INFO, {
          title = "<< Shell Command Output >>",
        })
      end
    end,
  })
end, { nargs = '+' })

-- OOO: Add an autocommand to detect :! commands and show a warning
vim.api.nvim_create_autocmd("ShellCmdPost", {
  pattern = "*",
  callback = function()
    vim.notify("Warning: Use :S instead of :! for shell commands.", vim.log.levels.WARN,
      { title = "!! Shell Command Warning !!" })
  end,
})
