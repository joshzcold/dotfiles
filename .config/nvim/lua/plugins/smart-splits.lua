return {
  {
    "mrjones2014/smart-splits.nvim",
    init = function ()
      vim.keymap.set('n', '<C-A-h>', require('smart-splits').resize_left)
      vim.keymap.set('n', '<C-A-j>', require('smart-splits').resize_down)
      vim.keymap.set('n', '<C-A-k>', require('smart-splits').resize_up)
      vim.keymap.set('n', '<C-A-l>', require('smart-splits').resize_right)

      vim.keymap.set('n', '<leader>r', require('smart-splits').start_resize_mode, {desc = "resize mode"})
    end,
    config = function()
      require("smart-splits").setup({})
    end,
  },
}
