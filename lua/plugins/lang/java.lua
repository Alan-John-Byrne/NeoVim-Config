--  PLUGIN: Configuring the 'nvim-java.nvim' plugin for java development support.
return {
  "nvim-java/nvim-java",
  dependencies = {
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          jdtls = {
            -- IMPORTANT: Your custom jdtls settings goes here. (NOT COVERED IN THE NVIM-JAVA PLUGIN DOCS UNDER CONFIGURATION, BECAUSE IT'S SEPARATE)
            settings = {
              java = { -- XXX: Configuring Java Settings.
                format = {
                  enabled = false, -- We don't want annoying formatting for java.
                  -- settings = { COULD USE CUSTOM XML FILE FOR GRANULAR CONTROL
                  -- url = "path to formatter settings.xml"
                  -- }
                },
              },
            },
          },
        },
        setup = {
          jdtls = function()
            require("java").setup({
              -- NOTE: Your custom nvim-java configuration goes here. (COVERED IN THE NVIM-JAVA PLUGIN DOCS UNDER CONFIGURATION)
              jdk = {
                -- XXX: Disabling installation of jdk 17 through mason.nvim. (We're going to be using JDK 21)
                auto_install = false,
              },
              -- NOTE: List of files that exists as a root for projects.
              -- IMPORTANT: VITAL FOR DEBUGGING, ALWAYS SET NEW DIRECTORIES AS DEBUGGER WILL SEARCH THESE.
              root_markers = { -- XXX: Keep only those directories you want to use.
                "code_testing",
              },
            })
          end,
        },
      },
    },
  },
}
