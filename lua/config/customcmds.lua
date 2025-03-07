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
