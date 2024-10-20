-- PLUGIN: Installing the 'harpoon' plugin: Allows for easy switching between common files you are working on.
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = function(_, opts) -- XXX: 'opts' being passed into the function, is the opts table of the base LazyVim configuration for the plugin.
    local harpoon = require("harpoon")

    -- IMPORTANT: Extending the opts table of the original LazyVim plugin.
    opts = vim.tbl_extend("force", opts, { --  XXX: 'force' means we overwrite any keys in the left table (opts).
      -- NOTE: Not passing any options would still extend the base LazyVim plugin options table.
      settings = {
        sync_on_ui_close = true,
      },
    })

    -- XXX: Setup prior to further configuration.
    harpoon:setup(opts)

    -- NOTE: Basic Keymaps: (Overwriting some with clearer descriptions)
    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():add()
    end, { desc = "[A]dd file to harpoon." })

    vim.keymap.set("n", "<leader>h", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "[O]pen Harpoon" })

    vim.keymap.set("n", "<C-p>", function()
      harpoon:list():prev()
    end, { desc = "Navigate to previous harpoon file" })

    vim.keymap.set("n", "<C-n>", function()
      harpoon:list():next()
    end, { desc = "Navigate to next harpoon file" })
  end,
}
