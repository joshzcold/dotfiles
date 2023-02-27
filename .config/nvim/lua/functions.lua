-- set Jenkinsfile filetype on word 'pipeline' in groovy file types
vim.cmd([[
  au BufRead *.groovy if search('pipeline', 'nw') | set ft=Jenkinsfile | setlocal indentexpr=GetJavascriptIndent()  | endif
  au BufRead,BufNewFile */playbooks/*.yml set filetype=yaml.ansible
]])

-- set yaml to yaml.ansible when hosts,tasks,roles is present
vim.cmd([[
  au BufRead *.yaml,*.yml if search('tasks:\|- name:', 'nw') | set ft=yaml.ansible | endif
  au BufRead *.conf,*.conf.* if search('http {\|server {', 'nw') | set ft=nginx | endif
  autocmd Filetype yaml.* set makeprg=ansible-lint\ -p\ --nocolor\ -x\ role-name,package-latest,fqcn-builtins
  autocmd Filetype python set makeprg=pylama\ --format\ pylint
]])


vim.cmd([[
  au BufRead *.json setlocal winbar=%{luaeval('require\"jsonpath\".get()')}
]])

function BitBucketReview()
  local Job = require'plenary.job'

  Job:new({
    command = 'open_review.sh',
    env = { ['a'] = 'b' },
    on_exit = function(j, return_val)
      print(return_val)
      print(j:result())
    end,
  }):sync() -- or start()
end

vim.cmd([[
function! GitPushWithReview()
      execute("Gwrite")
      let message = input("commit message: ")
      execute("Git commit -m '".message."' ")
      execute("Git pushg")
endfunction
function! GitPush()
      execute("Gwrite")
      let message = input("commit message: ")
      execute("Git commit -m '".message."' ")
      execute("Git push")
endfunction

function! JenkinsLint()
      let jenkins_url = "https://jenkins-devops.secmet.co"
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

