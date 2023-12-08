return {
  -- smarter increment decrement G-^a
  {
    'monaqa/dial.nvim',
    config = function()
      vim.api.nvim_set_keymap('n', '<C-a>', require('dial.map').inc_normal(), { noremap = true })
      vim.api.nvim_set_keymap('n', '<C-x>', require('dial.map').dec_normal(), { noremap = true })
      vim.api.nvim_set_keymap('v', '<C-a>', require('dial.map').inc_visual(), { noremap = true })
      vim.api.nvim_set_keymap('v', '<C-x>', require('dial.map').dec_visual(), { noremap = true })
      vim.api.nvim_set_keymap('v', 'g<C-a>', require('dial.map').inc_gvisual(), { noremap = true })
      vim.api.nvim_set_keymap('v', 'g<C-x>', require('dial.map').dec_gvisual(), { noremap = true })
    end,
  },
  -- smarter vim dot-repeat
  { 'tpope/vim-repeat' },
  -- lots of useful lua functions plugins like to use
  { 'nvim-lua/plenary.nvim' },
  -- in .json files evaluate the xpath and display at top
  {
    'phelipetls/jsonpath.nvim',
    lazy = true,
    ft = 'json',
  },
  {
    'joshzcold/yaml.nvim',
    lazy = true,
    ft = 'yaml',
  },
  -- Get a diff view on an visual selection
  { 'AndrewRadev/linediff.vim' },
  -- table format text on a regex
  { 'godlygeek/tabular' },

  -- follow symlinks when opening them
  -- { "aymericbeaumet/vim-symlink", dependencies = { "moll/vim-bbye" } },

  -- detects color codes in text and colors them in buffer
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  -- allows sudo password prompt inside vim
  { 'lambdalisue/suda.vim', cmd = { 'SudaWrite' } },

  -- :YankMacro [register]
  { 'jesseleite/nvim-macroni' },

  {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    lazy = true,
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
    event = { 'User KittyScrollbackLaunch' },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^2.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      require('kitty-scrollback').setup()
    end,
  },
}
