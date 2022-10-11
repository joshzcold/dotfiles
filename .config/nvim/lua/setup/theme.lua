vim.g.vscode_style = "dark"
vim.g.vscode_italic_comment = 1
vim.g.vscode_transparent = 1

require("github-theme").setup({
  theme_style = "dark_default",
  overrides = function (c)
    -- fix the look of yaml in this color scheme
    vim.api.nvim_create_autocmd("FileType", { pattern = { "yaml", "yaml.ansible" }, command = "hi TSField guifg=#3fb950" })
    return{ }
  end
})

-- highlighting tweaks
vim.api.nvim_set_hl(0, "SpellBad", { sp = "#325905", underline = true })
vim.api.nvim_set_hl(0, "SpellCap", { sp = "#000c7a", underline = true })
vim.api.nvim_set_hl(0, "SpellRare", { sp = "#000c7a", underline = true })
vim.api.nvim_set_hl(0, "SpellLocal", { sp = "#6c007a", underline = true })

vim.api.nvim_set_hl(0, "Search", { reverse = true })
vim.api.nvim_set_hl(0, "Cursor", { reverse = true })

vim.cmd([[
au BufRead,BufNewFile *.groovy set filetype=Jenkinsfile
autocmd FileType groovy setlocal commentstring=//\ %s
autocmd FileType Jenkinsfile setlocal commentstring=//\ %s
]])

vim.cmd([[
" Output the current syntax group when pressing f10
nnoremap <f10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'  . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"  . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>
  ]])

vim.cmd([[
" force syntax reload
autocmd BufEnter,InsertLeave * :syntax sync fromstart
]])
