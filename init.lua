--[[
Things I want to add:
  - Command to open terminal emulator at currently directory
  - Command to open terminal emulator at project root dir
--]]

vim.g.mapleader = "<Space>"
vim.opt.relativenumber = false

require("bootstrap-lazyvim")

vim.keymap.set("n", "%", "<cmd>%y+<CR>", { desc = "Copy current buffer content" })
vim.keymap.set("n", "<space>X", "<CMD>.source<CR>", { desc = "Source current line" })
vim.keymap.set("v", "X", "<CMD>'<,'>source<CR>", { desc = "Source current selection" })
