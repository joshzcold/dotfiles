return {
  "folke/edgy.nvim",
  event = "VeryLazy",
  opts = {
    animate = {
      enabled = false,
      fps = 200, -- frames per second
      cps = 240, -- cells per second
      on_begin = function()
        vim.g.minianimate_disable = true
      end,
      on_end = function()
        vim.g.minianimate_disable = false
      end,
      -- Spinner for pinned views that are loading.
      -- if you have noice.nvim installed, you can use any spinner from it, like:
      -- spinner = require("noice.util.spinners").spinners.circleFull,
      spinner = {
        frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
        interval = 80,
      },
    },
    options = {
      left = { size = 30 },
      bottom = { size = 10 },
      right = { size = 30 },
      top = { size = 10 },
    },
    bottom = {
      "Trouble",
      { ft = "qf",       title = "QuickFix" },
      { ft = "fugitive", title = "Git",     size = { height = 20 } },
      {
        ft = "help",
        size = { height = 20 },
        -- only show help buffers
        filter = function(buf)
          return vim.bo[buf].buftype == "help"
        end,
      },
    },
    left = {
      -- Neo-tree filesystem always takes half the screen height
      {
        title = "NvimTree",
        ft = "NvimTree",
        size = { height = 0.5, width = 0.3 },
      },
      {
        ft = "Outline",
        pinned = true,
        open = "SymbolsOutline",
      },
    },
    right = {
      -- {
      --   ft = "toggleterm",
      --   size = { width = 0.35 },
      --   -- exclude floating windows
      --   filter = function(buf, win)
      --     return vim.api.nvim_win_get_config(win).relative == ""
      --   end,
      -- },
    },
  },
}
