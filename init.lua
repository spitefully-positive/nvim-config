--[[
Things I want to add:
  - Command to open terminal emulator at currently directory
  - Command to open terminal emulator at project root dir
--]]

vim.g.mapleader = "<Space>"
vim.opt.relativenumber = false

-- TODO: Fix the "Undefined global `vim`." issue, before I loose my mind...

-- TODO: Dive into Comment.nvim and see if there is an easy end to this
-- => Comment.nvim might fix my inconsistent cursor with its sticky option
--   -> Ctrl-C always puts the cursor at the end of the line when in Insert-Mode and at the beginning of the line when in Normal-Mode
--   -> Also it looses my selection when in Visual-Mode. (But that might be way harder to fix)
-- For quick fixes it might be enought to use the hidden vim._comment module maybe I will take a look at that in the future

-- TODO: Install https://github.com/echasnovski/mini.surround to for great "surround-motions"

-- TODO: Continue removing default configuration.
-- I created a plugins directory where all the LazyVim default Plugins will go
-- => My plan is to piece by piece sort out what I want and what I do not want,
-- and in the end full integreate the "lua/default-LazyVim-plugins"-folder into my "lua/plugins"-folder
-- (Execute "nvim /home/jojochr/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins" compare with the old state or fetch some more extras)

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

-- Keybinds to start external terminal
vim.keymap.set("n", "<space>tT", function()
  open_terminal()
end, { desc = "Open external Terminal (at project root)" })
vim.keymap.set("n", "<space>tt", function()
  open_terminal(nil, vim.fn.expand("%:p:h"))
end, { desc = "Open external Terminal (in current buffer dir)" })

-- Internal terminal for quick debugging
vim.keymap.set("n", "<space>ti", function()
  vim.cmd.new()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 12)
  vim.wo.winfixheight = true
  vim.cmd.term()
  vim.api.nvim_input("i")
end, { desc = "Open integrated Terminal (at project root)" })
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>") -- Easily hit escape in terminal mode

-- Quick commenting
vim.keymap.set("i", "<C-c>", "<Esc>gcc A", { desc = "Toggle comment current line" })
vim.keymap.set("n", "<C-c>", "gcc", { desc = "Toggle comment current line" })
vim.keymap.set("v", "<C-c>", "gc", { desc = "Toggle comment on selection" })

-- For developing my nvim config
vim.keymap.set("n", "%", "<cmd>%y+<CR>", { desc = "Copy current buffer content" })
vim.keymap.set("n", "<space>X", "<CMD>.source<CR>", { desc = "Source current line" })
vim.keymap.set("v", "X", "<CMD>'<,'>source<CR>", { desc = "Source current selection" })
