vim.g.mapleader = "<Space>"
vim.opt.number = true
vim.opt.relativenumber = true

-- Register a bunch of filetypes
require("autocommands_for_filetypes")
