-- INFO: Autocmds are automatically loaded on the VeryLazy event.

-- NOTE: Show currently running linters for the current buffer's file type.
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

-- NOTE: Show all paths within the vim runtimepath.
vim.api.nvim_create_user_command("ShowPaths", function()
  local runtimepath = vim.o.rtp
  local runtimepaths = require("my_functions").split(runtimepath, ",")
  for index, path in ipairs(runtimepaths) do
    print("Index " .. index .. " : " .. path)
  end
end, {})
