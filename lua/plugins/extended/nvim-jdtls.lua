-- IMPORTANT: THIS CONFIG WILL NOT APPEAR AS IS WITHIN LSPINFO AS LAZYVIM ACTUALLY HANDLES THIS FOR YOU,
-- BY CONVERTING YOUR CONFIG SO IT CAN USE IT BEHIND THE SCENES.
return {
  {
    "mfussenegger/nvim-jdtls",
    config = function() -- WARN: COMPLETELY OVERWRITING THE LAZYVIM CONFIG TO ALLOW CUSTOM CONTROL.
      -- First requiring jdtls (yes the plugin is requiring itself, this is normal)
      local jdtls = require("jdtls")
      -- Creating a place to store the current workspace.
      vim.g.current_workspace = ""
      -- Listening for a BufEnter event when going into a java file.
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*.java",
        callback = function()
          -- If there are no jdtls clients, continue.
          -- NOTE:  Individual Project Data Directory Configuration:
          local workspace_name = "\\." .. vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":t") -- The name of the workspace, based on the name of the parent root directory.
          local workspace_dir = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h") .. workspace_name -- The workspace directory for our project. Based on the name of the root dir.
          local project_root_dir_full = vim.fn.expand("%:p:h") -- The root directory for our project. Based on the workspace_name within.
          local project_root_dir_tail = vim.fn.fnamemodify(project_root_dir_full, ":p:h:t") -- The root directory for our project. Based on the workspace_name within.
          -- Output tests:
          print("Workspace name: " .. workspace_name)
          print("Workspace directory: " .. workspace_dir)
          print("Project directory long: " .. project_root_dir_full)
          print("Project directory short: " .. project_root_dir_tail)
          -- 1st: Creating the config:
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
              "-data",
              workspace_dir,
            },
            -- IMPORTANT:💀 Must be set to the specifics of your machine.
            -- This is the default if not provided, you can remove it. Or adjust as needed.
            -- One dedicated LSP server & client will be started per unique root_dir
            --
            -- vim.fs.root requires Neovim 0.10.
            -- If you're using an earlier version, use: require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
            root_dir = vim.fs.root(0, { project_root_dir_tail }),
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
          -- 2nd: We need to check if jdtls is running already in another project. If so, shut it down, so we can attach a new instance to another project.
          if vim.g.current_workspace ~= workspace_name and vim.g.current_workspace ~= "" then
            -- If jdtls is already running, turn it off, allowing to switch projects.
            for _, client in ipairs(vim.lsp.get_clients()) do
              if client.name == "jdtls" then
                client.stop()
              end
            end
            -- IMPORTANT: DELAYING THE RESTARTING OF JDTLS IN A DIFFERENT PROJECT, PREVENTING RACE CONDITIONS.
            vim.defer_fn(function()
              print("Starting new jdtls client after project switch delay...")
              -- Storing the current workspace: (So we can check if we've switched projects later).
              vim.g.current_workspace = workspace_name
              -- This starts a new client & server,
              -- or attaches to an existing client & server depending on the `root_dir`.
              jdtls.start_or_attach(config)
            end, 3000)
          else
            -- Storing the workspace on initial entry in any java project. NOTE: MUST BE DONE FIRST FOR COMPARISON ON ENTRY INTO OTHER PROJECTS, ALLOWING FOR SWITCH.
            vim.g.current_workspace = workspace_name
            -- This starts a new client & server,
            -- or attaches to an existing client & server depending on the `root_dir`.
            jdtls.start_or_attach(config)
          end
        end,
      })
    end,
  },
}
