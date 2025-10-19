if true then return {} end -- IMPORTANT: ALWAYS RETURNING NOTHING! THESE ARE DOCS!
return {
  "mfussenegger/nvim-jdtls",
  enabled = true,
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  config = function()
    -- TODO: Listening for a 'BufEnter' event when going into a java file.
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*.java",
      callback = function()
        -- TODO: Setting a unique workspace directory for each project to be used by JDTLS (this is standard).
        -- WARN: The workspace meta-data directory must be in the root directory, above all project files.
        local base_path = vim.fn.expand("~/coding/javadev/")
        local project_root_path = vim.fs.root(0, { 'pom.xml', '.git', '.mvn', 'mvnw', 'gradlew', 'build.gradle' })
        local workspace_dir_name = vim.fn.fnamemodify(project_root_path, ':t') .. "_workspace"
        local workspace_dir_path = base_path .. "workspaces/" .. workspace_dir_name
        -- NOTE: Creating the configuration for the LSP.
        local config = {
          -- The command that starts the language server
          -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
          cmd = {

            -- IMPORTANT:💀 Must be set to the specifics of your machine.
            "java", -- or '/path/to/java17_or_newer/bin/java' depends on if the `java.exe` (java runtime) is in your $PATH env variables.

            -- INFO: Options specified in the documentation:
            "-Declipse.application=org.eclipse.jdt.ls.core.id1", -- Specifying the Eclipse app ID to run (the JDT Language Server).
            "-Dosgi.bundles.defaultStartLevel=4",                -- Setting the default start level for OSGi bundles in the Eclipse runtime.
            "-Declipse.product=org.eclipse.jdt.ls.core.product", -- Defines which Eclipse product to run.
            "-Dlog.protocol=true",                               -- Enables logging of the Language Server Protocol (LSP) communication.
            "-Dlog.level=ALL",                                   -- Setting the logging level to capture all logs (maximum verbosity).
            "-Xmx1g",                                            -- Setting the maximum Java heap size to 1 gigabyte.
            "--add-modules=ALL-SYSTEM",                          -- REMEMBER: Making all modules in the JDK available.
            "--add-opens", "java.base/java.util=ALL-UNNAMED",
            "--add-opens", "java.base/java.lang=ALL-UNNAMED",    -- Both of these settings open specific packages in the Java module system to allow deep reflection access from unnamed modules.

            -- IMPORTANT:💀 Must be set to the specifics of your machine. (Manual Installation required - MASON NOT COMPATIBLE)
            "-jar",
            base_path ..
            ".setup_config/jdtls/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_1.7.0.v20250519-0528.jar",
            -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^                                            ^^^^^^^^^^^^^^^^^^
            -- Must point to the                                                      Change this to
            -- eclipse.jdt.ls installation                                            the actual version

            -- IMPORTANT:💀 Must be set to the specifics of your machine. (Manual Installation required - MASON NOT COMPATIBLE)
            "-configuration",
            base_path .. ".setup_config/jdtls/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_mac",
            -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^      ^^^^^^^^^^
            -- Must point to the                Change to one of `linux`, `win` or `mac`
            -- eclipse.jdt.ls installation      Depending on your system.
            --

            -- IMPORTANT:💀 Must be set to the specifics of your machine.
            -- See `data directory configuration` section in the README
            "-data", -- NOTE: JDTLS needs to know how each project is structured and we point it to the metadata / .workspace folder.
            workspace_dir_path,
          },
          -- IMPORTANT:💀 Must be set to the specifics of your machine.
          -- This is the default if not provided, you can remove it. Or adjust as needed.
          -- One dedicated LSP server & client will be started per unique root_dir
          --
          -- vim.fs.root requires Neovim v0.10+.
          -- If you're using an earlier version, use: require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
          root_dir = project_root_path,

          -- Here you can configure eclipse.jdt.ls specific settings
          -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
          -- for a list of options
          settings = {
            java = {
              -- OOO: This is the default version of java used on the system.
              home = "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home",
              configuration = {
                -- WARN: See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request And search for `interface RuntimeOption`
                -- NOTE: The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
                -- IMPORTANT: Even if nvim-jdtls requires the Java 21 JDK to be set as 'JAVA_HOME' we can still use the plugin for projects built in other versions.
                -- REMEMBER: The 'archetype' / template used for generating the project scaffolding using Maven, determines the version of the JDK used in that project.
                runtimes = {
                  {
                    name = "JavaSE-17",
                    path = "/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home",
                  },
                  {
                    name = "JavaSE-21",
                    path = "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home",
                  },
                },
              },
              format = { -- IMPORTANT: Eclipse LSP format settings file. Allows for the altering of the default formatter provided by the eclipse formatter.
                settings = {
                  url = base_path .. ".setup_config/eclipse-java-google-style.xml",
                },
              },
            },
          },
          -- INFO:
          -- Language server `initializationOptions`:
          -- You need to extend the `bundles` with paths to jar files if you want to
          -- use additional eclipse.jdt.ls plugins. See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation.
          -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this.
          init_options = {
            bundles = {    -- IMPORTANT: If using nvim-jdtls, you MUST CLONE THE REPO of the java-debug plugin manually via git, and paste it's path here.
              vim.fn.glob( -- WARN: If you move the java-debug folder (the one containing the plugin you just cloned), YOU CAN'T. Clone into that new folder, and rebuild.
                base_path ..
                ".setup_config/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.53.2.jar"
              ),
            },
          },
        }
        -- NOTE: Requiring the LSP and attaching it to the java buffer, using the configuration.
        local jdtls = require("jdtls")
        jdtls.start_or_attach(config)
      end,
    })
  end,
}
