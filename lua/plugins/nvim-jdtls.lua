-- XXX: Java Project Setup: (When working on large projects and / or publishing packages to registries later)
-- When using the 'gradle init --type java-application' command to setup a java project, it will NOT generate
-- a unique package structure. This can cause naming conflicts if you later publish to Maven Central, or any
-- other registry. To prevent this, you MUST MANUALLY CREATE the proper 'src directory hierarchies' inside the
-- 'app' module of the java project.
-- --------------------------------------------------(STEPS)--------------------------------------------------------
-- 0.  If present, within the base root directory (above all projects), DELETE the '.workspace' metadata directory. It stores all project structures.
-- 1.  CREATE a new src hierarchy for the "main files" -> 'src/main/java/com/<yourname>/<projectname>/App.java'.
-- 2.  CREATE a new src hierarchy for the "test files" -> 'src/test/java/com/<yourname>/<projectname>/AppTest.java'.
-- 3.  DELETE the old src directory hierarchies. (i.e.: DELETE -> 'src/main/java/App.java' & 'src/main/java/AppTest.java')
-- 4.  MOVE the 'App.java' file into the new main src hierarchy.
-- 5.  MOVE the 'AppTest.java' file into the new test src hierarchy.
-- 6.  UPDATE the package declaration within the src files to reflect the hierarchy changes. (i.e.: CHANGE TO -> 'com.<yourname>.<projectname>')
-- 7.  If present, DELETE the '.gradle' directory in the root of the java project.
-- 8.  If present, DELETE the 'build' directory within the 'app' module / directory, thats in the root of the java project.
-- 9.  Within the 'build.gradle.kts' file, RE-SET the main class to reflect previous changes / steps. (i.e.: CHANGE TO -> 'mainClass.set("com.<yourname>.<projectname>.App")')
-- 10. Within the root of the java project, RUN a 'clean build' using the following command -> 'gradle clean build'.
-- Extra. If the nvim-jdtls LSP is already running (BEFORE STEP 0.), run the nvim command 'JdtRestart' to restart the LSP server, now you're all set!
-- ---------------------------------------------------(FIN)---------------------------------------------------------
-- PLUGIN: 'nvim-jdtls.nvim' extends the capabilities of the built-in LSP support in Neovim, to support Java.
-- TODO: Requirements:
-- > JAVASE 21.*.* (set as both the default binary and as 'JAVA_HOME')
-- > java-debug 0.53.1 from "https://github.com/microsoft/java-debug"
-- > gradle-7.3.3 from "https://gradle.org/releases/"
-- IMPORTANT: Requirments must be installed manually, not via the mason package manager!
return {
  "mfussenegger/nvim-jdtls",
  enabled = true,
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  config = function()
    -- TODO: Setting the workspace directory used by JDTLS, for all projects (this is standard).
    -- WARN: The workspace meta-data directory must be in the root directory, above all project files.
    local base_path = "D:\\4-Personal-OneDrive\\OneDrive\\Coding\\javadev\\"
    local workspace_dir_name = ".workspace"
    local workspace_dir_path = base_path .. workspace_dir_name
    -- TODO: Listening for a 'BufEnter' event when going into a java file.
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*.java",
      callback = function()
        -- NOTE: Creating the configuration for the LSP.
        local config = {
          -- The command that starts the language server
          -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
          cmd = {

            -- IMPORTANT:💀 Must be set to the specifics of your machine.
            "Java", -- or '/path/to/java17_or_newer/bin/java' depends on if the `java.exe` (java runtime) is in your $PATH env variables.

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
            base_path .. ".setup_config\\jdtls\\plugins\\org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar",
            -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^                                            ^^^^^^^^^^^^^^^^^^
            -- Must point to the                                                      Change this to
            -- eclipse.jdt.ls installation                                            the actual version

            -- IMPORTANT:💀 Must be set to the specifics of your machine. (Manual Installation required - MASON NOT COMPATIBLE)
            "-configuration",
            base_path .. ".setup_config\\jdtls\\config_win",
            -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^      ^^^^^^^^^^
            -- Must point to the                Change to one of `linux`, `win` or `mac`
            -- eclipse.jdt.ls installation      Depending on your system.

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
          root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }),

          -- Here you can configure eclipse.jdt.ls specific settings
          -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
          -- for a list of options
          settings = {
            java = {
              configuration = {
                -- WARN: See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request And search for `interface RuntimeOption`
                -- NOTE: The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
                runtimes = {            -- IMPORTANT: Even if nvim-jdtls requires the Java 21 JDK to be set as 'JAVA_HOME' we can still use the plugin for projects built in other versions.
                  {
                    name = "JavaSE_21", -- Create Java 21 Projects.
                    path = "C:\\Program Files\\Java\\jdk-21",
                  },
                  {
                    name = "JavaSE_17", -- Create Java 17 Projects.
                    path = "C:\\Program Files\\Java\\jdk-17",
                  },
                },
              },
              format = { -- IMPORTANT: Eclipse LSP format settings file. Allows for the altering of the default formatter provided by the eclipse formatter.
                settings = {
                  url = base_path .. ".setup_config\\eclipse-java-google-style.xml",
                },
              },
            },
          },
          -- REMEMBER:
          -- Language server `initializationOptions`:
          -- You need to extend the `bundles` with paths to jar files if you want to
          -- use additional eclipse.jdt.ls plugins. See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation.
          -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this.
          init_options = {
            bundles = {    -- IMPORTANT: If using nvim-jdtls, you MUST CLONE THE REPO of the java-debug plugin manually via git, and paste it's path here.
              vim.fn.glob( -- WARN: If you move the java-debug folder (the one containing the plugin you just cloned), YOU CAN'T. Clone into that new folder, and rebuild.
                base_path ..
                ".setup_config\\java-debug\\com.microsoft.java.debug.plugin\\target\\com.microsoft.java.debug.plugin-0.53.1.jar",
                true
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
