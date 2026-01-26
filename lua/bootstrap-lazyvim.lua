-- Bootstrap LazyVim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- Add lazypath to lua execution path
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { -- installl LazyVim and enable default plugins for now
      "LazyVim/LazyVim",
      opts = { news = { lazyvim = false, neovim = false } },
      import = "lazyvim.plugins",
    },
    -- Import my lua/plugins directory
    { import = "plugins" },
  },
  defaults = {
    lazy = false, -- Dont lazy load by default, breaks some things...
    version = false, -- Always use latest by default
  },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = true, -- notify on update
  },
  performance = {
    rtp = {
      -- disable vim builtin plugins I dont want
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
