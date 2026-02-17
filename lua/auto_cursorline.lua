-- Copied from Folke who had a great simple Idea here :)
-- After reading this code it seems like it should not work at all.
-- "Remember if it was enabled, only set if it was enabled before"
-- => This works because normal buffers have it enabled by default with my settings
-- => But windows like telescope do not have an "initial cursorline" and that's why it will not activate, after entering and exiting insert mode
-- (Yes all of this is because, it looks bad if you have a highlighted cursorline in telescope and other plugins...)

vim.o.cursorline = true
vim.o.cursorlineopt = "both"

local AUTO_CL_VAR_MANE = "auto_cursorline"

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  group = vim.api.nvim_create_augroup("disable_auto_cursorline", { clear = true }),
  callback = function()
    -- Remember if we had the cursorline enabled
    if vim.wo.cursorline then
      vim.api.nvim_win_set_var(0, AUTO_CL_VAR_MANE, true)
      vim.wo.cursorline = false
    end
  end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  group = vim.api.nvim_create_augroup("enable_auto_cursorline", { clear = true }),
  callback = function()
    -- Only enable cursorline if it was enabled before
    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, AUTO_CL_VAR_MANE)
    if ok and cl then
      vim.api.nvim_win_del_var(0, AUTO_CL_VAR_MANE)
      vim.wo.cursorline = true
    end
  end,
})
