return {
  {
    "mfussenegger/nvim-dap",
    keys = function() -- IMPORTANT: USING A FUNCTION TO RETURN A TABLE TO COMPLETELY OVERWRITE THE OTHER IRRELEVANT KEYMAPS FROM NVIM-DAP.
      return {
        { "<leader>d", "", desc = "+debug", mode = { "n", "v" } },
        {
          "<leader>dB",
          function()
            require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
          end,
          desc = "Breakpoint Condition",
        },
        {
          "<leader>db",
          function()
            require("dap").toggle_breakpoint()
          end,
          desc = "Toggle Breakpoint",
        },
        {
          "<leader>dc",
          function()
            require("dap").continue()
          end,
          desc = "Continue",
        },
        {
          "<leader>di",
          function()
            require("dap").step_into()
          end,
          desc = "Step Into",
        },
        {
          "<leader>do",
          function()
            require("dap").step_out()
          end,
          desc = "Step Out",
        },
        {
          "<leader>dO",
          function()
            require("dap").step_over()
          end,
          desc = "Step Over",
        },
        {
          "<leader>dp",
          function()
            require("dap").pause()
          end,
          desc = "Pause",
        },
        {
          "<leader>dt",
          function()
            require("dap").terminate()
          end,
          desc = "Terminate",
        },
      }
    end,
    opts = {}, -- Equivalent to calling .setup()
  },
}
