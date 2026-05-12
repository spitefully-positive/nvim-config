-- I use this file to set up a bunch of syntax highlighting stuff

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { vim.fn.expand("~") .. "/.config/mako/config" },
  command = "set syntax=dosini",
})
