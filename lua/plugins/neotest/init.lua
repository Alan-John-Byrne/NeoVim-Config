-- PLUGIN: The "neotest" plugin allows for testing via a number of different test frameworks.
return {
  { -- INFO: GLOBAL NEOTEST CONFIGURATION.
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "thenbe/neotest-playwright"
    },
    config = function()
      local neotest_utility = require("plugins.neotest.utility")
      -- Setting up the neotest suite.
      require('neotest').setup({
        -- OOO: CONSUMERS:
        consumers = {
          playwright = require('neotest-playwright.consumers').consumers,
        },
        -- SECTION: ADAPTER INTEGRATIONS:
        adapters = {
          -- ADAPTER: PLAYWRIGHT:
          -- IMPORTANT: To correctly switch projects (browsers), you must first,
          -- close the test buffer (i.e. / e.g.: 'example.spec.ts') for the summary
          -- window to refresh and for your chosen projects to load.
          require('neotest-playwright').adapter({
            options = {
              persist_project_selection = true,     -- Optional, persists project selection
              enable_dynamic_test_discovery = true, -- Enables CLI-based test discovery
              get_playwright_binary = function()
                return vim.loop.cwd() .. "/node_modules/.bin/playwright"
              end,
              get_playwright_config = function()
                return vim.loop.cwd() .. "/playwright.config.ts"
              end,
              get_cwd = function()
                return vim.loop.cwd()
              end,
              experimental = {
                telescope = {
                  -- WARN: Must use telescope. The 'NeotestPlaywrightProject' command,
                  -- will not work without this enabled.
                  enabled = true
                },
              },
              -- INFO: Dynamically loading in env variables to the neotest project.
              env = neotest_utility.find_node_proj_root_and_load_env_vars(),
            }
          })
          -- ADAPTER: ???:
          -- Next adapter???
        },
      })
      -- NOTE: Neotest Global / Shared Adapter Keybindings:
      local neotest = require('neotest')
      local wk = require("which-key")
      local notify = require("notify")
      wk.add({
        mode = { "n" },
        { "<leader>tt", function() neotest.run.run() end,                                        desc = "Run nearest test." },
        { "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end,                      desc = 'Run all tests in the current file.' },
        { "<leader>to", function() neotest.output.open({ enter = true, auto_close = true }) end, desc = "Open test output." },
        { "<leader>ts", function() neotest.summary.toggle() end,                                 desc = "Toggle test summary." },
        -- IMPORTANT: 'Playwright' and some other testing adapters may not be compatible with nvim-dap.
        {
          "<leader>td",
          function()
            if not neotest_utility.is_playwright_project() then
              neotest.run.run({ -- NOTE: If it's not a playwright project (i.e.: No 'playwright.config.ts / js is in the root of the npm project')
                strategy =
                "dap"
              })
            else
              notify("Playwright is not supported, use a playwright preset.", vim.log.levels.ERROR,
                { title = "Nvim-Dap" });
            end
          end,
          desc = "Debug nearest test."
        }, -- WARN: Cannot be used with Playwright, it doesn't support nvim dap.
      })
    end,
  },
  -- SECTION: ADAPTER CONFIGURATIONS:
  -- ADAPTER: PLAYWRIGHT:
  {
    "thenbe/neotest-playwright",
    dependencies = { 'nvim-telescope/telescope.nvim', },
    -- IMPORTANT: Ensures that the playwright summary updates on next test run.
    event = "VeryLazy",
    config = function()
      -- INFO: Playwright specific keymaps:
      -- WARN: Keymap for refreshing playwright data (effects summary tree).
      -- WARN: Keymap for selecting projects / browsers (effects summary tree).
      -- IMPORTANT: Customizing invocation of 'NeotestPlaywrightProject'.
      -- Allows for automatic refresh of summary data on project selection.
      local wk = require("which-key")
      wk.add({
        mode = { "n" },
        icon = { icon = "🛠", color = "yellow" },
        { "<leader>tp",  group = "Playwright Test Options" },
        { "<leader>tpa", function() require('neotest').playwright.attachment() end,              desc = 'Playwright: Attach to a running test.' },
        { "<leader>tpP", "<cmd>NeotestPlaywrightPreset<CR>",                                     desc = 'Playwright: Choose Presets.' },
        { "<leader>tpn", function() require("plugins.neotest.utility").refresh_playwright() end, desc = 'Playwright: Refresh data.' },
        { "<leader>tpp", function() require("plugins.neotest.utility").select_browsers() end,    desc = 'Playwright: Choose Browsers.' },
      })
    end
  }
  -- ADAPTER: ???:
}
