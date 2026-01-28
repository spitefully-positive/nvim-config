--[[
Things I want to add:
  - Command to open terminal emulator at currently directory
  - Command to open terminal emulator at project root dir
--]]

vim.g.mapleader = "<Space>"
vim.opt.relativenumber = false

require("bootstrap-lazyvim")

-- I have set up some custom langauge queries (e.G. for mise)
-- Thosose live in the after/queries directory
-- Quick explaination for the different query directories.
-- (They all get loaded by default, no require statement to add here)
-- ./queries       => Queries here will override existing queries (use when you know better than the author or you are creating a new query for a new language)
-- ./after/queries => Queries here get loaded after and, by convention, extend existing queries (This was great to extend the toml syntax hightlighting, with mise's custom hightlighting)
-- Ther structure should always be "queries/<language>/<query-type>.scm" (e.g., queries/rust/highlights.scm)

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
