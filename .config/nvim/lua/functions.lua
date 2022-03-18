-- set Jenkinsfile filetype on word 'pipeline' in groovy file types
vim.cmd([[
  au BufRead *.groovy if search('pipeline', 'nw') | set ft=Jenkinsfile | setlocal indentexpr=GetJavascriptIndent()  | endif
  au BufRead,BufNewFile */playbooks/*.yml set filetype=yaml.ansible
  au BufRead *.groovy  setlocal indentexpr=GetJavascriptIndent()
  autocmd Filetype Jenkinsfile set makeprg=JenkinsLint()
]])

-- set yaml to yaml.ansible when hosts,tasks,roles is present
vim.cmd([[
  au BufRead *.yaml,*.yml if search('tasks:\|- name:', 'nw') | set ft=yaml.ansible | endif
  autocmd Filetype yaml.* set makeprg=ansible-lint\ -p\ --nocolor\ -x\ role-name,package-latest,fqcn-builtins
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

vim.cmd(
  [[ autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif ]]
)

vim.cmd([[
  au TermOpen * setlocal nospell
]])
