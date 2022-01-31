vim.g.vscode_style = "dark"

vim.cmd([[colorscheme vscode ]])

vim.cmd([[highlight Comment cterm=italic gui=italic]])

-- highlighting tweaks
vim.cmd([[
hi DiffAdd ctermfg=none guifg=#007504 guibg=none ctermbg=none
hi DiffChange ctermfg=none guifg=#a37500 guibg=none ctermbg=none
hi DiffDelete ctermfg=none guifg=#7a0000 guibg=none ctermbg=none
autocmd vimenter * hi Normal guibg=#202020
autocmd vimenter * hi SignColumn guibg=NONE ctermbg=NONE
autocmd vimenter * hi LineNr guibg=NONE ctermbg=NONE

au BufRead,BufNewFile *.groovy set filetype=Jenkinsfile

autocmd FileType groovy setlocal commentstring=//\ %s
autocmd FileType Jenkinsfile setlocal commentstring=//\ %s
]])

vim.cmd([[
" Output the current syntax group
nnoremap <f10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'  . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"  . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>
  ]])

vim.cmd([[
" force syntax reload
autocmd BufEnter,InsertLeave * :syntax sync fromstart
]])
