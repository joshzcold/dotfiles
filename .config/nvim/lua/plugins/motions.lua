return {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    'ThePrimeagen/harpoon',
    opts = {},
    config = function(_, opts)
      require('harpoon').setup(opts)

      vim.api.nvim_set_keymap('n', '<leader>ha', '<cmd>lua require("harpoon.mark").add_file()<cr>', { desc = 'Harpoon add file' })
      vim.api.nvim_set_keymap('n', '<leader>hj', '<cmd>lua require("harpoon.ui").nav_next()<cr>', { desc = 'Harpoon next' })
      vim.api.nvim_set_keymap('n', '<leader>hk', '<cmd>lua require("harpoon.ui").nav_prev()<cr>', { desc = 'Harpoon prev' })
      vim.api.nvim_set_keymap('n', '<leader>hh', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', { desc = 'Harpoon ui' })

      vim.api.nvim_set_keymap('n', '<leader>h1', '<cmd>lua require("harpoon.ui").nav_file(1)<cr>', { desc = 'Harpoon to file 1' })
      vim.api.nvim_set_keymap('n', '<leader>h2', '<cmd>lua require("harpoon.ui").nav_file(2)<cr>', { desc = 'Harpoon to file 2' })
      vim.api.nvim_set_keymap('n', '<leader>h3', '<cmd>lua require("harpoon.ui").nav_file(3)<cr>', { desc = 'Harpoon to file 3' })
      vim.api.nvim_set_keymap('n', '<leader>h4', '<cmd>lua require("harpoon.ui").nav_file(4)<cr>', { desc = 'Harpoon to file 4' })
      vim.api.nvim_set_keymap('n', '<leader>h5', '<cmd>lua require("harpoon.ui").nav_file(5)<cr>', { desc = 'Harpoon to file 5' })
      vim.api.nvim_set_keymap('n', '<leader>h6', '<cmd>lua require("harpoon.ui").nav_file(6)<cr>', { desc = 'Harpoon to file 6' })
      vim.api.nvim_set_keymap('n', '<leader>h7', '<cmd>lua require("harpoon.ui").nav_file(7)<cr>', { desc = 'Harpoon to file 7' })
      vim.api.nvim_set_keymap('n', '<leader>h8', '<cmd>lua require("harpoon.ui").nav_file(8)<cr>', { desc = 'Harpoon to file 8' })
      vim.api.nvim_set_keymap('n', '<leader>h9', '<cmd>lua require("harpoon.ui").nav_file(9)<cr>', { desc = 'Harpoon to file 9' })
    end,
  },
}
