return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-mini/mini.icons" },
  config = function()
    CustomOilBar = function()
      local path = vim.fn.expand("%")
      path = path:gsub("oil://", "")

      return " " .. vim.fn.fnamemodify(path, ":.")
    end

    require("oil").setup({
      columns = { "permissions", "icon" },
      constrain_cursor = false,
      keymaps = {
        -- View help | There are more commands in oil.nvim by default than I configure here
        ["g?"] = { "actions.show_help", mode = "n" },

        -- Open files
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },

        ["<C-c>"] = { "actions.close", mode = "n" },
        ["<C-p>"] = "actions.preview",

        -- Interacting with cwd
        ["-"] = { "actions.parent", mode = "n" }, -- Open parent dir in oil
        ["_"] = { "actions.open_cwd", mode = "n" }, -- Open cwd
        ["`"] = { "actions.cd", mode = "n" }, -- Set cwd to the current dir

        -- Other nicities
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
      },
      view_options = {
        show_hidden = true,
      },
      win_options = {
        winbar = "%{v:lua.CustomOilBar()}", -- Show file current oil directory at the top
      },
    })

    -- Open parent directory in current window
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end,
}
