vim.cmd([[
  colorscheme github_dark_default
]])

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
