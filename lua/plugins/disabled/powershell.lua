-- PLUGIN: Installing the 'powershell.nvim' plugin. It mostly provides
return {
  "TheLeoP/powershell.nvim",
  enabled = false, -- TESTING WARN: DOES NOT SUPPORT INTERACTIVE DEBUGGING THROUGH WRITE-HOST, THIS IS AN ISSUE WITH THE PLUGIN.
  opts = {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    bundle_path = "C:\\Users\\alanj\\AppData\\Local\\nvim-data\\mason\\packages\\powershell-editor-services",
    -- NOTE: The term "bundle_path" refers ot the file path where a 'bundle' of software components, assetss, or libraries is stored
    -- IMPORTANT: I chose to install the necessary "powershell-editor-services" LSP, via the Mason package manager, hence the above path.
    init_options = vim.empty_dict(),
    settings = vim.empty_dict(),
    shell = "pwsh",
  },
}

-- WARN: The following are the default dap configurations already included within the plugins config.
--dap.configurations.ps1 = {
--  {
--    name = "PowerShell: Launch Current File",
--    type = "ps1",
--    request = "launch",
--    script = "${file}",
--  },
--  {
--    name = "PowerShell: Launch Script",
--    type = "ps1",
--    request = "launch",
--    script = function()
--      return coroutine.create(function(co)
--        vim.ui.input({
--          prompt = 'Enter path or command to execute, for example: "${workspaceFolder}/src/foo.ps1" or "Invoke-Pester"',
--          completion = "file",
--        }, function(selected) coroutine.resume(co, selected) end)
--      end)
--    end,
--  },
--  {
--    name = "PowerShell: Attach to PowerShell Host Process",
--    type = "ps1",
--    request = "attach",
--    processId = "${command:pickProcess}",
--  },
--}
