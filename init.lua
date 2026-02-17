vim.g.mapleader = "<Space>"
vim.o.relativenumber = false

-- Set cursorline option and register corresponding autocommand
require("auto_cursorline")

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
