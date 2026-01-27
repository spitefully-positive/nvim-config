-- vim-fugitive: Git wrapper for Neovim
-- Provides :Git command interface, inline blame, side-by-side diffs, and more.
-- NOT lazy-loaded on purpose: Tim Pope (the author) strongly discourages lazy-loading
-- fugitive because its plugin file defines commands, maps, autocommands, and a public
-- API that all need to be available immediately. The autoload mechanism already handles
-- deferred loading of the heavy implementation internally.
return {
  "tpope/vim-fugitive",
  lazy = false, -- Must NOT be lazy-loaded (see comment above)

  keys = {
    -- Main fugitive summary window (stage, unstage, commit interactively with g?)
    { "<leader>gg", "<cmd>Git<cr>", desc = "Git Fugitive (summary)" },

    -- Blame the current file inline
    { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git Blame (fugitive)" },

    -- Side-by-side diff of the current file against the index
    { "<leader>ge", "<cmd>Gvdiffsplit<cr>", desc = "Git Diff Split (vertical)" },

    -- Git log for the current file
    { "<leader>gl", "<cmd>Git log --oneline<cr>", desc = "Git Log (oneline)" },
    { "<leader>gL", "<cmd>Git log --oneline --all --graph<cr>", desc = "Git Log (graph)" },

    -- Stage/write current file
    { "<leader>gw", "<cmd>Gwrite<cr>", desc = "Git Stage Current File" },

    -- Checkout current file from index (discard changes)
    { "<leader>gr", "<cmd>Gread<cr>", desc = "Git Checkout Current File" },
  },
}
