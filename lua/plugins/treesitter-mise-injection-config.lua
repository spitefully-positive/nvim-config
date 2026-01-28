return {
  { -- This enables extended syntax hightlighting when working with mise
    -- I got all this from a guide on the mise docs => https://mise.jdx.dev/mise-cookbook/neovim.html
    "nvim-treesitter/nvim-treesitter",
    init = function()
      require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
        local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
        local filename = vim.fn.fnamemodify(filepath, ":t")

        -- Always do on the primary mise config path
        if string.match(filepath, "mise/config.toml$") ~= nil then
          return true
        end

        -- Else on all toml files that have mise in their name
        return string.match(filename, ".*mise.*%.toml$") ~= nil
      end, { force = true, all = false })
    end,
  },
}
