-- vim.cmd([[ colorscheme github_dark_default ]])
-- vim.cmd([[colorscheme tokyonight-night]])
-- vim.cmd([[colorscheme catppuccin-mocha]])
vim.cmd([[colorscheme kanagawa ]])

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

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "kanagawa",
    callback = function()
        if vim.o.background == "light" then
            vim.fn.system("kitty +kitten themes Kanagawa_light")
        elseif vim.o.background == "dark" then
            vim.fn.system("kitty +kitten themes Kanagawa_dragon")
        else
            vim.fn.system("kitty +kitten themes Kanagawa")
        end
    end,
})
