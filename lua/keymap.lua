vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Go down half a page" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Go up half a page" })

vim.keymap.set("n", "<Leader>%", "<Cmd>%y+<CR>", { desc = "Copy current buffer content" })
vim.keymap.set("v", "<Leader>%", "<Esc>ggVG", { desc = "Highlight entire file" })

vim.keymap.set("n", "<Leader>X", "<Cmd>.source<CR>", { desc = "Source current line" })
vim.keymap.set("v", "<Leader>X", "<Cmd>'<,'>source<CR>", { desc = "Source current selection" })

-- Easy keybind to escape integrated terminal (who set Ctrl + Backslash as the default???)
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

require("exterminal").create_keymaps()

vim.keymap.set("n", "<Leader>tI", function()
  vim.cmd.new()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 12)
  vim.wo.winfixheight = true
  vim.cmd.term()
  vim.api.nvim_input("i")
end, { desc = "Open integrated Terminal (at project root)" })
