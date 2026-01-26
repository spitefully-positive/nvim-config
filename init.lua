--[[
Things I want to add:
  - Command to open terminal emulator at currently directory
  - Command to open terminal emulator at project root dir
--]]

vim.g.mapleader = "<Space>"
vim.opt.relativenumber = false

require("bootstrap-lazyvim")

--- Default terminal command to execute
START_TERM_CMD = "uwsm app -- $(xdg-terminal-exec --print-cmd)"

--- Opens a terminal with optional command and working directory
--- @param start_cmd? string The terminal command to execute (default: uwsm app -- xdg-terminal-exec)
--- @param working_dir? string The working directory for the terminal (default: current Vim working directory)
local function open_terminal(start_cmd, working_dir)
  start_cmd = start_cmd or START_TERM_CMD
  working_dir = working_dir or vim.fn.getcwd()
  os.execute("setsid --fork " .. start_cmd .. ' --working-directory="' .. working_dir .. '" > /dev/null')
end

vim.api.nvim_create_user_command("OpenExtTermInRootDir", function()
  open_terminal()
end, { desc = "Opens External Terminal (in project root)" })

vim.api.nvim_create_user_command("OpenExtTermInBufferDir", function()
  open_terminal(nil, vim.fn.expand("%:p:h"))
end, { desc = "Opens External Terminal (in project root)" })

vim.keymap.set("n", "<space>tT", "<cmd>OpenExtTermInRootDir<cr>", {})
vim.keymap.set("n", "<space>tt", "<cmd>OpenExtTermInBufferDir<cr>", {})

vim.keymap.set("n", "%", "<cmd>%y+<CR>", { desc = "Copy current buffer content" })
vim.keymap.set("n", "<space>X", "<CMD>.source<CR>", { desc = "Source current line" })
vim.keymap.set("v", "X", "<CMD>'<,'>source<CR>", { desc = "Source current selection" })
