require 'functions'
require 'autocmd'
require 'options'
require 'mappings'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup('plugins', {
  change_detection = {
    notify = false,
  },
  performance = {
    cache = {
      enabled = false,
    },
    rtp = {
      disabled_plugins = {
        'matchparen',
        -- 'gzip',
        -- 'netrwPlugin',
        -- 'tarPlugin',
        -- 'tohtml',
        'zipPlugin',
        'tutor',
      },
    },
  },
})
require 'theme'
require 'term'
