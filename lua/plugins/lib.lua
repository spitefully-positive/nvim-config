return {
  -- Library Icons that are not meant for me as a user,
  -- but for other plugin outhors

  -- NUI is delivers reusable UI components
  { "MunifTanjim/nui.nvim", lazy = true },

  -- And we also need lots of icons
  { "nvim-tree/nvim-web-devicons", opts = {} },
  {
    "nvim-mini/mini.icons",
    version = false,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
  },
}
