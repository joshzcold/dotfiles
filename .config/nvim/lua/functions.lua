-- User Functions
function GetRepoName()
  local handle = io.popen([[git config --get remote.origin.url | sed 's/.*\/\([^ ]*\/[^.]*\).*/\1/' || true]])
  local result = handle:read("*a")
  if result then
    return result.gsub(result, "%s+", "")
  end
  handle:close()
end

vim.cmd([[
au BufRead *.groovy if search('pipeline', 'nw') | set ft=Jenkinsfile | setlocal indentexpr=GetJavascriptIndent()  | endif
au BufRead *.groovy  setlocal indentexpr=GetJavascriptIndent()
]])

vim.cmd([[
function! GitPush()
      execute("Gwrite")
      let message = input("commit message: ")
      execute("Git commit -m '".message."' ")
      execute("Git pushg")
endfunction

function! JenkinsLint()
      let jenkins_url = "https://10.29.158.99"
      let crumb_command = "curl -s -k \"".jenkins_url.'/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)"'
      let jenkins_crumb = system(crumb_command)
      let validate_command = "curl -k -X POST -H ".jenkins_crumb." -F \"jenkinsfile=<".expand('%:p')."\" ".jenkins_url."/pipeline-model-converter/validate"
      echo validate_command
      let result = system(validate_command)
      echo result
endfunction
]])

-- highlighting tweaks
vim.cmd([[
hi DiffAdd ctermfg=none guifg=#007504 guibg=none ctermbg=none
hi DiffChange ctermfg=none guifg=#a37500 guibg=none ctermbg=none
hi DiffDelete ctermfg=none guifg=#7a0000 guibg=none ctermbg=none
hi Normal guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
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