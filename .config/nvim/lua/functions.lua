
function _G.Increment()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local result = vim.api.nvim_get_current_line()
  print(result)
end

vim.cmd([[
au BufRead *.groovy if search('pipeline', 'nw') | set ft=Jenkinsfile | setlocal indentexpr=GetJavascriptIndent()  | endif
au BufRead,BufNewFile */playbooks/*.yml set filetype=yaml.ansible
au BufRead *.groovy  setlocal indentexpr=GetJavascriptIndent()
]])

vim.cmd([[autocmd Filetype yaml.* set makeprg=ansible-lint\ -p\ --nocolor\ -x\ role-name]])

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


vim.cmd(
  [[ autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif ]]
)
