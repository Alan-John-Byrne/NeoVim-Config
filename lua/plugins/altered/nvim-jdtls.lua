-- IMPORTANT: THIS CONFIG WILL APPEAR AS IS WITHIN LSPINFO AS LSPCONFIG ACTUALLY HANDLES THIS FOR YOU.
-- WARN: FOR JDTLS TO WORK, THE WORKSPACE DIRECTORY MUST BE ABOVE ALL PROJECT FILES, AND GRADLE OR MAVEN MUST BE USED TO CREATE PROJECTS.
return {
  "mfussenegger/nvim-jdtls",
  config = function()
    -- TODO: Initial: First requiring jdtls (yes the plugin is requiring itself, this is normal).
    local jdtls = require("jdtls")
    -- WARNING: This config function fully overwrites the default LazyVim configuration
    -- to allow for a custom setup.
    -- NOTE: The default 'opts' table is excluded here as it's not passed
    -- (i.e., this function is not in the form of function(_, opts)).
    -- This helps prevent duplicate LSP clients from attaching to the same buffer.
    --TODO: Setting the workspace directory used by JDTLS, for all projects.
    local workspace_dir_name = ".workspace" -- The name of the workspace directory. Just keeping it simple.
    local workspace_dir_path = "C:\\Users\\alanj\\Documents\\PowerShell\\code_testing\\javadev\\" .. workspace_dir_name -- Getting the full path to the workspace directory.
    -- IMPORTANT: Global variable necessary for storing the current project. Required for switching.
    vim.g.current_project = ""
    -- TODO: LISTENING FOR A BUFENTER EVENT WHEN GOING INTO A JAVA FILE.
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*.java",
      callback = function()
        -- TODO: 1ST: Getting the name of the project. Based on the project directory. (Catering for 'code_testing' directory, in case project is named 'testing' or 'code')
        local project_name = "\\" .. vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":t") .. "\\"
        -- TODO: 2nd: Creating the config using the extracted settings:
        local config = {
          -- The command that starts the language server
          -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
          cmd = {

            -- IMPORTANT:💀 Must be set to the specifics of your machine.
            "Java", -- or '/path/to/java17_or_newer/bin/java' depends on if the `java.exe` (java runtime) is in your $PATH env variables

            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xmx1g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",

            -- IMPORTANT:💀 Must be set to the specifics of your machine.
            "-jar",
            "C:\\Users\\alanj\\AppData\\Local\\nvim-data\\mason\\packages\\jdtls\\plugins\\org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar",
            -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                                                         ^^^^^^^^^^^^^^
            -- Must point to the                                                                                       Change this to
            -- eclipse.jdt.ls installation                                                                             the actual version

            -- IMPORTANT:💀 Must be set to the specifics of your machine.
            "-configuration",
            "C:\\Users\\alanj\\AppData\\Local\\nvim-data\\mason\\packages\\jdtls\\config_win",
            -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                           ^^^
            -- Must point to the                                                         Change to one of `linux`, `win` or `mac`
            -- eclipse.jdt.ls installation                                               Depending on your system.

            -- IMPORTANT:💀 Must be set to the specifics of your machine.
            -- See `data directory configuration` section in the README
            "-data", -- NOTE: JDTLS needs to know how each project is structured and we point it to the metadata / workspace folder.
            workspace_dir_path,
          },
          -- IMPORTANT:💀 Must be set to the specifics of your machine.
          -- This is the default if not provided, you can remove it. Or adjust as needed.
          -- One dedicated LSP server & client will be started per unique root_dir
          --
          -- vim.fs.root requires Neovim 0.10.
          -- If you're using an earlier version, use: require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
          root_dir = vim.fs.root(0, { "gradlew" }),

          -- Here you can configure eclipse.jdt.ls specific settings
          -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
          -- for a list of options
          settings = {
            java = {},
          },
          -- Language server `initializationOptions`
          -- You need to extend the `bundles` with paths to jar files
          -- if you want to use additional eclipse.jdt.ls plugins.
          --
          -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
          -- IMPORTANT: Activating JDTLS only when interacting with java files.
          --
          -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
          init_options = {
            bundles = {
              vim.fn.glob(
                "C:\\Users\\alanj\\AppData\\Local\\nvim-data\\mason\\packages\\java-debug-adapter\\extension\\server\\com.microsoft.java.debug.plugin-*.jar",
                true
              ),
            },
          },
        }
        -- NOTE: 3rd: We need to check if jdtls is running already in another project.
        -- If so, shut it down, so we can attach a new instance to another project.
        if vim.g.project_name ~= project_name and vim.g.project_name ~= "" then
          -- If jdtls is already running, turn it off. Else If there are no jdtls clients, just continue.
          for _, client in ipairs(vim.lsp.get_clients()) do
            if client.name == "jdtls" then
              client.stop()
            end
          end
          -- IMPORTANT: DELAYING THE RESTARTING OF JDTLS IN A DIFFERENT PROJECT, PREVENTING RACE CONDITIONS.
          vim.defer_fn(function()
            print("Starting new jdtls client after project switch delay...")
            local jdtls_new = require("jdtls")
            -- Storing the current workspace: (So we can check if we've switched projects later).
            vim.g.project_name = project_name
            -- This starts a new client & server,
            -- or attaches to an existing client & server depending on the `root_dir`.
            jdtls_new.start_or_attach(config)
          end, 3000) -- NOTE: 3000 milliseconds = 3 seconds.
        else
          -- Storing the workspace on initial entry in any java project.
          -- NOTE: MUST BE DONE FIRST FOR COMPARISON ON ENTRY INTO THE FIRST PROJECT, ALLOWING FOR SWITCHING TO AND FROM OTHER PROJECTS.
          vim.g.project_name = project_name
          -- This starts a new client & server,
          -- or attaches to an existing client & server depending on the `root_dir`.
          jdtls.start_or_attach(config)
        end
      end,
    })
  end,
}
