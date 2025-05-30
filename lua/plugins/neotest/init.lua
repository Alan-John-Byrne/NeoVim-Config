-- PLUGIN: The "neotest" plugin allows for testing via a number of different test frameworks.
return {
  -- NOTE: Telescope fuzzy finder is a dependency of neotest.
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
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
      -- Setting up the neotest suite.
      require('neotest').setup({
        -- XXX: CONSUMERS:
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
            }
          })
          -- ADAPTER: ???:
          -- Next adapter???
        },
      })
      -- NOTE: Neotest Global / Shared Keybindings:
      local neotest = require('neotest')
      vim.keymap.set("n", "<leader>tt", function()
        neotest.run.run()
      end, { desc = "Run nearest test" })

      vim.keymap.set("n", "<leader>tf", function()
        neotest.run.run(vim.fn.expand("%"))
      end, { desc = "Run all tests in current file" })

      vim.keymap.set("n", "<leader>to", function()
        neotest.output.open({ enter = true, auto_close = true })
      end, { desc = "Open test output" })

      vim.keymap.set("n", "<leader>ts", function()
        neotest.summary.toggle()
      end, { desc = "Toggle test summary" })

      vim.keymap.set("n", "<leader>td", function() -- NOTE: Cannot be used with Playwright, it doesn't support nvim dap.
        neotest.run.run({ strategy = "dap" })
      end, { desc = "Debug nearest test" })
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
      vim.keymap.set(
        "n",
        '<leader>ta',
        function()
          require('neotest').playwright.attachment()
        end,
        { desc = 'Playwright: Attach to a running test.' }
      )
      vim.keymap.set(
        "n",
        '<leader>tP',
        "<cmd>NeotestPlaywrightPreset<CR>",
        { desc = 'Playwright: Run all tests with a select preset.', }
      )
      -- WARN: Keymap for refreshing playwright data (effects summary tree).
      vim.keymap.set(
        "n",
        '<leader>tn',
        function()
          require("helper_methods").refresh_playwright()
        end,
        { desc = 'Playwright: Refresh summary.', }
      )
      -- WARN: Keymap for selecting projects / browsers (effects summary tree).
      -- IMPORTANT: Customizing invocation of 'NeotestPlaywrightProject'.
      -- Allows for automatic refresh of summary data on project selection.
      vim.keymap.set(
        "n",
        '<leader>tp',
        function()
          require("helper_methods").select_browsers()
        end,
        { desc = 'Playwright: Run all tests in the project' }
      )
    end
  }
  -- ADAPTER: ???:
}
