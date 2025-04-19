return {
  -- {
  --   "stevearc/dressing.nvim",
  --   opts = {},
  --   enabled = true
  -- },
  {
    "kevinhwang91/nvim-bqf",
    opts = {},
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      callout = {
        story = { raw = "[!STORY]", rendered = "  Story", highlight = "RenderMarkdownHint" },
        spike = { raw = "[!SPIKE]", rendered = "  Spike", highlight = "RenderMarkdownInfo" },
      },
    },
    init = function()
      local prefix = "RenderMarkdown"
      vim.api.nvim_set_hl(0, prefix .. "Code", { bg = "#151b23" })
      vim.api.nvim_set_hl(0, prefix .. "CodeInline", { bg = "#151b23" })
      vim.api.nvim_set_hl(0, prefix .. "H4Bg", { bg = "#003F00", fg = "#9ACD32" })
      vim.api.nvim_set_hl(0, prefix .. "H5Bg", { bg = "#720072", fg = "#EE82EE" })
      vim.api.nvim_set_hl(0, prefix .. "H6Bg", { bg = "#000078", fg = "#6A5ACD" })
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
  },

  {
    "3rd/image.nvim",
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {
      processor = "magick_cli",
    }
  },
  {
    "max397574/colortils.nvim",
    cmd = { "Colortils" },
    opts = {},
  },
}
