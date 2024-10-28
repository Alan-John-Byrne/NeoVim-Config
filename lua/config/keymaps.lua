-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- XXX: Keymaps for inserting a line above or below the current line.
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

-- XXX: Keymap for opening up a terminal session.
vim.keymap.set("n", "<leader>t", ":split | term<CR>")

-- XXX: Set the current working directory to the buffer's directory, and Print the current working directory.
vim.keymap.set("n", "<leader>S", ":cd %:p:h<CR>", { desc = "Set to cwd.", noremap = true, silent = true })
vim.keymap.set("n", "<leader>P", ":pwd<CR>", { desc = "Print cwd.", noremap = true, silent = true })
