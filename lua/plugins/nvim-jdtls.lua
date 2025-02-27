-- PLUGIN: OVERWRITING THE 'NVIM-JDTLS.NVIM' PLUGIN TO SUPPORT JAVA DEVELOPMENT.
-- IMPORTANT: THIS CONFIG WILL APPEAR AS IS WITHIN LSPINFO AS LSPCONFIG ACTUALLY HANDLES THIS FOR YOU.
-- WARN: FOR JDTLS TO WORK, THE WORKSPACE DIRECTORY MUST BE ABOVE ALL PROJECT FILES, AND GRADLE OR MAVEN MUST BE USED TO CREATE PROJECTS.
-- NOTE: REQUIREMENTS:
-- TODO: - JAVASE 21.*.* (set as both the default binary and as 'JAVA_HOME')
-- TODO: - java-debug 0.53.1 from "https://github.com/microsoft/java-debug"
-- TODO: - gradle-7.3.3 from "https://gradle.org/releases/"
-- IMPORTANT: REQUIRMENTS FOR THIS PLUGIN ARE LISTED, AND MUST BE INSTALLED MANUALLY, NOT VIA THE MASON PACKAGE MANAGER!!!!
return {
  "mfussenegger/nvim-jdtls",
  enabled = true,
  lazy = true, -- NOTE: Lazy load must be included here, it's not done automatically. Plugin is loaded based on the config function, which lazy.nvim won't detect.
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  config = function()
    -- TODO: Initial: First requiring jdtls (yes the plugin is requiring itself, this is normal).
    -- WARNING: This config function fully overwrites the default LazyVim configuration to allow for a custom setup.
    -- NOTE: The default 'opts' table is excluded here as it's not passed
    -- (i.e., this function is not in the form of function(_, opts)).
    -- This helps prevent duplicate LSP clients from attaching to the same buffer.
    --TODO: Setting the workspace directory used by JDTLS, for all projects (which is standard).
    local workspace_dir_name = ".workspace" -- The name of the workspace directory.
    local workspace_dir_path = "C:\\Users\\alanj\\Documents\\PowerShell\\coding\\javadev\\" .. workspace_dir_name
    -- TODO: LISTENING FOR A BUFENTER EVENT WHEN GOING INTO A JAVA FILE.
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*.java",
      callback = function()
        -- TODO: 1ST: Getting the name of the project. Based on the project directory. (Catering for 'coding' directory, in case project is named 'testing' or 'code')
        local project_name = "\\" .. vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":t") .. "\\"
        -- TODO: 2nd: Creating the config using the extracted settings:
        local config = {
          -- The command that starts the language server
          -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
          cmd = {

            -- IMPORTANT:💀 Must be set to the specifics of your machine.
            "Java", -- or '/path/to/java17_or_newer/bin/java' depends on if the `java.exe` (java runtime) is in your $PATH env variables

            -- IMPORTANT:💀 Must be set to the specifics of your machine. (Manual Installation required - MASON NOT COMPATIBLE)
            "-jar",
            "C:\\Users\\alanj\\Documents\\Powershell\\coding\\javadev\\.setup_config\\jdtls\\plugins\\org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar",
            -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                                                         ^^^^^^^^^^^^^^
            -- Must point to the                                                                                       Change this to
            -- eclipse.jdt.ls installation                                                                             the actual version

            -- IMPORTANT:💀 Must be set to the specifics of your machine. (Manual Installation required - MASON NOT COMPATIBLE)
            "-configuration",
            "C:\\Users\\alanj\\Documents\\Powershell\\coding\\javadev\\.setup_config\\jdtls\\config_win",
            -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                                  ^^^
            -- Must point to the                                                                Change to one of `linux`, `win` or `mac`
            -- eclipse.jdt.ls installation                                                      Depending on your system.

            -- IMPORTANT:💀 Must be set to the specifics of your machine.
            -- See `data directory configuration` section in the README
            "-data", -- NOTE: JDTLS needs to know how each project is structured and we point it to the metadata / .workspace folder.
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
            java = {
              configuration = {
                -- WARN: See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request And search for `interface RuntimeOption`
                -- NOTE: The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
                runtimes = { -- IMPORTANT: Even if nvim-jdtls requires the Java 17 jdk to be set as 'JAVA_HOME' we can still use the plugin for projects built in later versions.
                  {
                    name = "JAVASE_21",
                    path = "C:\\Program Files\\Java\\jdk-21",
                  },
                },
              },
              format = { -- IMPORTANT: Eclipse LSP format settings file. Allows for the altering of the default formatter provided by the eclipse formatter.
                settings = {
                  url =
                  "C:\\Users\\alanj\\Documents\\Powershell\\coding\\javadev\\.setup_config\\eclipse-java-google-style.xml",
                },
              },
            },
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
            bundles = {    -- IMPORTANT: If using nvim-jdtls, you MUST CLONE THE REPO of the java-debug plugin manually via git, and paste it's path here.
              vim.fn.glob( -- WARN: If you move the java-debug folder (the one containing the plugin you just cloned), YOU CAN'T. Clone into that new folder, and rebuild.
                "C:\\Users\\alanj\\Documents\\PowerShell\\coding\\javadev\\.setup_config\\java-debug\\com.microsoft.java.debug.plugin\\target\\com.microsoft.java.debug.plugin-0.53.1.jar",
                true
              ),
            },
          },
        }
        -- NOTE: 3rd: Require jdtls and attach to the java related buffer, within the project, using the configuration above.
        local jdtls = require("jdtls")
        jdtls.start_or_attach(config)
      end,
    })
  end,
}
