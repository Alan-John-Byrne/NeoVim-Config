--- INFO:  A set of utility methods for making configuring programming language support in Neovim, easier.
---@class M
local M = {}
--- Gets / returns the Mason package path as a string.
--- Returns a string, which is the name of the package installed via mason.
---@param package_name  string  The name of the package.
---@return string
---@nodiscard
function M.get_mason_package_path(package_name)
  return string.format(vim.fn.expand("$MASON/packages/%s"), package_name)
end

--- Setup 'npm-groovy-lint' linter/formatter.
--- WARN: For some reason this isn't configured properly within mason,
--- so this linter cannot be included within 'mason-nvim-lint' and 'mason-conform'
--- as an 'ensured-install'. Because it will not be detected.
---
---@return nil
function M.npm_groovy_lint_setup()
  -- Disabling required field / parameter error:
  ---@diagnostic disable-next-line: missing-fields
  require("lint").linters.npm_groovy_lint = {
    cmd = "npm-groovy-lint",
    stdin = false,
    args = { "--no-insight", "--noserver", "--output", "json", "--", "$FILENAME" },
    stream = "stdout",
    ignore_exitcode = false,
    parser = function(output, bufnr)
      local diagnostics = {}
      local ok, decoded = pcall(vim.json.decode, output)
      if not ok or type(decoded) ~= "table" or not decoded.files then
        return diagnostics
      end

      local file_diagnostics = decoded.files[vim.api.nvim_buf_get_name(bufnr)]
      if not file_diagnostics or not file_diagnostics.errors then
        return diagnostics
      end

      for _, err in ipairs(file_diagnostics.errors) do
        table.insert(diagnostics, {
          lnum = err.line - 1,
          col = err.column - 1,
          end_col = err.endColumn and (err.endColumn - 1) or nil,
          severity = vim.diagnostic.severity.WARN, -- or use err.severity to map appropriately
          message = err.message,
          source = "npm-groovy-lint",
        })
      end

      return diagnostics
    end,
  }
end

-- Exporting the module.
return M
