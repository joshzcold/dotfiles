return {
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      vim.api.nvim_set_keymap("n", "<C-A-h>", "<cmd> lua require('smart-splits').resize_left()<cr>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<C-A-j>", "<cmd> lua require('smart-splits').resize_down()<cr>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<C-A-k>", "<cmd> lua require('smart-splits').resize_up()<cr>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<C-A-l>", "<cmd> lua require('smart-splits').resize_right()<cr>", { noremap = true })
    end,
    opts = {}
  },
}
