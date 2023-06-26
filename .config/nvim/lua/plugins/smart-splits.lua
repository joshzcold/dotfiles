return {
  {
    "mrjones2014/smart-splits.nvim",
    init = function ()
      vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
      vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
      vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
      vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)

      vim.keymap.set('n', '<leader>r', require('smart-splits').start_resize_mode, {desc = "resize mode"})
    end,
    config = function()
      require("smart-splits").setup({})
    end,
  },
}
