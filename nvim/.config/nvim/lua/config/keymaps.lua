-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>oyd", "<cmd>ObsidianYesterday<CR>", { noremap = true, desc = "Open Yesterday's Note" })
vim.keymap.set("n", "<leader>otd", "<cmd>ObsidianToday<CR>", { noremap = true, desc = "Open Today's Note" })
vim.keymap.set("n", "<leader>otm", "<cmd>ObsidianTomorrow<CR>", { noremap = true, desc = "Open Tomorrow's Note" })
