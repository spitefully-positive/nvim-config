local m = {}

--- Opens a external terminal
--- @param working_dir? string The working directory for the terminal (default: current Vim working directory)
--- @param start_term_emulator_cmd? string Command executed to start the terminal (default: "uwsm app -- xdg-terminal-exec")
local function open_external_terminal(working_dir, start_term_emulator_cmd)
  start_term_emulator_cmd = start_term_emulator_cmd or "uwsm app -- $(xdg-terminal-exec --print-cmd)"
  working_dir = working_dir or vim.fn.getcwd()
  os.execute("setsid --fork " .. start_term_emulator_cmd .. ' --working-directory="' .. working_dir .. '" > /dev/null')
end

--- Call this to setup my terminal keymaps
function m.create_keymaps()
  vim.keymap.set("n", "<Leader>tt", function()
    open_external_terminal(vim.fn.expand("%:p:h"))
  end, { desc = "Open external Terminal (in current buffer dir)" })

  vim.keymap.set("n", "<Leader>tT", open_external_terminal, { desc = "Open external Terminal (at project root)" })
end

return m
