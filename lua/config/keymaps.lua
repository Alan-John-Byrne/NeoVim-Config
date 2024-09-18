-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- XXX: Keybinds for inserting a line above or below the current line.
vim.keymap.set(
  "n",
  "<leader>o",
  "o<Esc>xxxxxxxxxxxxxxxxxxxxxxk",
  { desc = "Insert line below.", noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>O",
  "O<Esc>xxxxxxxxxxxxxxxxxxxxxxj",
  { desc = "Insert line above.", noremap = true, silent = true }
)

-- XXX: Disabling arrow keys in normal mode.
vim.keymap.set("n", "<left>", function()
  print("Use h to move left!")
end, { noremap = true, silent = true, desc = "Remind to use h instead of left arrow" })

vim.keymap.set("n", "<right>", function()
  print("Use l to move right!")
end, { noremap = true, silent = true, desc = "Remind to use l instead of right arrow" })
