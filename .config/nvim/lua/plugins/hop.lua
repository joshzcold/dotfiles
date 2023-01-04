return {
  {
    "phaazon/hop.nvim",
    lazy = true,
    cmd = {
      "HopWord",
      "HopLine",
    },
    init = function()
      vim.keymap.set("n", "<leader>ff", function()
        vim.cmd([[:HopWord<cr>]])
      end, { desc = "Hop To Word" })
      vim.keymap.set("n", "<leader>fl", function()
        vim.cmd([[:HopLine<cr>]])
      end, { desc = "Hop To Line" })
    end,
    config = function()
      require("hop").setup()
    end,
  },
}
