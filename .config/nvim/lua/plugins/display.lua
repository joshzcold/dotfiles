return {
  {
    "shortcuts/no-neck-pain.nvim",
    lazy = true,
    cmd = {
      "NoNeckPain",
    },
    init = function()
      vim.keymap.set("n", "<leader>zn", function()
        vim.cmd([[:NoNeckPain]])
      end, { desc = "No Neck Pain" })
    end,
    config = function()
      require("no-neck-pain").setup({
        width = 200,
        buffers = {
          -- scratchPad = {
          --   enabled = true
          -- }
        },
      })
    end,
  },
  -- fancy editing mode for less distraction
  {
    "Pocco81/true-zen.nvim",
    dependencies = { "folke/twilight.nvim" },
    init = function()
      vim.keymap.set("n", "<leader>zz", function()
        vim.cmd([[:TZAtaraxis]])
      end, { desc = "Zen Mode" })
    end,
    cmd = { "TZAtaraxis" },
    config = function()
      require("true-zen").setup({
        modes = {
          ataraxis = {
            shade = "dark", -- if `dark` then dim the padding windows, otherwise if it's `light` it'll brighten said windows
            backdrop = 0, -- percentage by which padding windows should be dimmed/brightened. Must be a number between 0 and 1. Set to 0 to keep the same background color
            minimum_writing_area = { -- minimum size of main window
              width = 180,
              height = 44,
            },
            quit_untoggles = true, -- type :q or :qa to quit Ataraxis mode
            padding = { -- padding windows
              left = 52,
              right = 52,
              top = 0,
              bottom = 0,
            },
            callbacks = { -- run functions when opening/closing Ataraxis mode
              open_pre = nil,
              open_pos = nil,
              close_pre = nil,
              close_pos = nil,
            },
          },
        },
        integrations = {
          twilight = true, -- enable twilight (ataraxis)
          lualine = true, -- hide nvim-lualine (ataraxis)
        },
      })
    end,
  },
}
