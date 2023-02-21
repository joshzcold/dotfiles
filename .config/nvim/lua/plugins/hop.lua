return {
  {
    "phaazon/hop.nvim",
    lazy = true,
    cmd = {
      "HopWord",
      "HopChar1",
      "HopLine",
    },
    init = function()
      vim.keymap.set("n", "<leader>ff", function()
        vim.cmd([[:HopWord]])
      end, { desc = "Hop To Word" })
      vim.keymap.set("n", "<leader>fl", function()
        vim.cmd([[:HopLine]])
      end, { desc = "Hop To Line" })
    end,
    config = function()
      require("hop").setup()
    end,
  },
}
