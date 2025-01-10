vim.cmd([[
  colorscheme github_dark_default
]])
-- highlighting tweaks
vim.api.nvim_set_hl(0, "SpellBad", { sp = "#325905", underline = true })
vim.api.nvim_set_hl(0, "SpellCap", { sp = "#000c7a", underline = true })
vim.api.nvim_set_hl(0, "SpellRare", { sp = "#000c7a", underline = true })
vim.api.nvim_set_hl(0, "SpellLocal", { sp = "#6c007a", underline = true })
vim.api.nvim_set_hl(0, "StatusLine", { fg = "#8b949e", bg = nil })

vim.api.nvim_set_hl(0, "Search", { reverse = true })
vim.api.nvim_set_hl(0, "Cursor", { reverse = true })

vim.cmd([[
  autocmd FileType groovy setlocal commentstring=//\ %s
  autocmd FileType Jenkinsfile setlocal commentstring=//\ %s
]])

vim.api.nvim_set_hl(0, "LspInlayHint", { bg = "#0a0c0f", fg = "#6e7681", })


local palette = require('github-theme.palette').load('github_dark_default')

vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = palette.black.base, fg = palette.white.bright, })
vim.api.nvim_set_hl(0, "TelescopeMatching", { bg = palette.black.base, fg = palette.red.bright, })
