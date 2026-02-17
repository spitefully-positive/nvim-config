return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "LazyFile",
    -- cmd = { "TodoTrouble", "TodoTelescope" },
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
      { "<leader>xt", "<Cmd>Trouble todo toggle<CR>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<Cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<CR>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<Leader>st", "<Cmd>TodoTelescope cwd=%:p:h keywords=TODO,FIX,FIXME<CR>", desc = "Todo" },
      { "<Leader>sT", "<Cmd>TodoTelescope cwd=%:p:h <CR>", desc = "All todo-comments.nvim keywords" },
    },
    config = function()
      require("todo-comments").setup()
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- optional but recommended
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
  },
}
