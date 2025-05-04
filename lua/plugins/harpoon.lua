-- PLUGIN: Altering the 'harpoon' plugin, allows for easy switching between common files you are working on.
return {
  "ThePrimeagen/harpoon",
  enabled = true,     --TESTING
  event = "VeryLazy", -- NOTE: Booting harpoon2 after nvim starts up.
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    -- INFO:  This would usually be "Booting harpoon2 only when it's keybindings are used",
    -- but instead this time it's just for getting the proper arrow icons to show up. Harpoon
    -- sets these icons in the background for keybindings in which-key for some reason.
    { "<leader>ha", mode = { "n" }, desc = "Add to harpoon" },
    { "<leader>hh", mode = { "n" }, desc = "Open harpoon" },
  },
  config = function()
    local harpoon = require("harpoon")

    -- XXX: Setup prior to further configuration.
    harpoon.setup({
      settings = {
        sync_on_ui_close = true
      }
    })

    -- NOTE: Basic Keymaps: (Overwriting some with clearer descriptions)
    vim.keymap.set("n", "<leader>ha", function()
      harpoon:list():add()
    end, { desc = "[A]dd file to harpoon." })

    vim.keymap.set("n", "<leader>hh", function()
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
