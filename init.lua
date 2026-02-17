vim.g.mapleader = "<Space>"
vim.o.relativenumber = false

-- Set cursorline option and register corresponding autocommand
require("auto_cursorline")

-- TODO: Fix the "Undefined global `vim`." issue, before I loose my mind...

-- TODO: Install https://github.com/echasnovski/mini.surround to for great "surround-motions"

-- TODO: Install https://github.com/numToStr/Comment.nvim to fix commenting

-- TODO: Install https://github.com/mg979/vim-visual-multi for multi line editing
-- Tutorial Linsk:
-- - https://youtu.be/p4D8-brdrZo?si=lfeMrmuERVQ2YYL6
-- - https://youtu.be/N-X_zjU5INs?si=jYOmuo9TghtmHdyT

-- TODO: Continue removing default configuration, to make this config "mine" :)
-- I created a plugins directory where all the LazyVim default Plugins will go
-- => My plan is to remove default plugins piece by piece, remove what I dont want and keep what I like
-- In the end full, the "lua/default-LazyVim-plugins"-folder should be fully integrated into my "lua/plugins"-folder, and be removed
-- (To compare with the original lazygit default plugins, execute "nvim /home/jojochr/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins")

--[[
 NOTE: I have set up some custom langauge queries (e.G. for mise)
       Queries gererally live insid the "./queries" and the "./after/queries" directory.
       All queries will get loaded by default (no require statement needed)
       Quick-Guide:
       - The file structure should always be: "<queries-directory>/<language>/<query-type>.scm" (e.g., queries/rust/highlights.scm)
       - ./queries       => Queries here will override existing queries (use when you know better than the author or you are creating a new query for a new language)
       - ./after/queries => Queries here get loaded after and, by convention, extend existing queries (e.g. great when I was extending toml syntax hightlighting for mise)
]]

require("bootstrap-lazyvim")
require("keymap")
