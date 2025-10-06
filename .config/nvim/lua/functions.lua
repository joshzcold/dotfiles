function SearchUp(dir_or_file)
  local found = nil
  local dir_to_check = nil
  -- get parent directory via vim expand
  local dir_template = "%:p:h"
  while not found and dir_to_check ~= "/" do
    dir_to_check = vim.fn.expand(dir_template)
    local check_path = dir_to_check .. "/" .. dir_or_file
    local check_git = dir_to_check .. "/" .. ".git"
    if vim.fn.isdirectory(check_path) == 1 or vim.fn.filereadable(check_path) == 1 then
      found = dir_to_check .. "/" .. dir_or_file
    else
      dir_template = dir_template .. ":h"
    end
    -- If we hit a .git directory then stop searching and return found even if nil
    if vim.fn.isdirectory(check_git) == 1 then
      return found
    end
  end
  return found
end

local function get_jira_tag()
  local handle = io.popen("git rev-parse --abbrev-ref HEAD")
  if not handle then
    return
  end
  local out_branch_tag = ""
  local result = handle:read("*a")
  local patterns = {
    "(%a%w%d%-%d+)",
    "(ENHANCEMENT)",
    "(CHORE)",
  }
  for _, p in ipairs(patterns) do
    local _, _, branch_tag = string.find(result, p)
    if branch_tag then
      out_branch_tag = branch_tag
    end
  end
  return out_branch_tag
end

local function git_write_with_input()
  vim.cmd.Gwrite()
  vim.api.nvim_command(":!git add $(readlink -f %)")
  local message = vim.fn.input("Commit message: ")
  vim.api.nvim_command(":!git commit -m " .. "'" .. message .. "'")
  return message
end

vim.api.nvim_create_user_command("GitPushWithReview", function()
  git_write_with_input()
  vim.api.nvim_command(":!git pushg")
end, {})

vim.api.nvim_create_user_command("GitPush", function()
  local message = git_write_with_input()
  vim.api.nvim_command(":!git push")
  vim.notify("Pushed --> " .. message)
end, {})

vim.api.nvim_create_user_command("SnippetEdit", function(opts)
  local config_path = vim.fn.stdpath("config")
  local snippet_path = config_path .. "/snippets/" .. opts.args
  if vim.fn.filereadable(snippet_path) == 1 then
    vim.cmd([[:e ]] .. snippet_path)
  else
    vim.notify("Snippet " .. snippet_path .. " not found.", vim.log.levels.ERROR)
  end
end, {
  nargs = 1,
  count = 1,
  complete = function(opts)
    local pattern = "*"
    if opts.args ~= nil then
      pattern = "*" .. opts.args
    end
    local snippet_path = vim.fn.stdpath("config") .. "/snippets/"
    local striped_files = {}
    local files = vim.fn.globpath(snippet_path, pattern, false, true)
    for _, v in ipairs(files) do
      table.insert(striped_files, vim.fs.basename(v))
    end
    return striped_files
  end,
})

-- supports moving on line wraps and appending to jump list when move is prepended by number
vim.api.nvim_create_user_command("MoveWithJumpList", function(opts)
  local count = tonumber(vim.v.count)
  if count == 0 then
    vim.cmd([[:norm! g]] .. opts.args)
  else
    if count > 0 then
      vim.cmd(":norm m'")
      vim.cmd([[:norm! ]] .. count .. opts.args)
    else
      vim.cmd([[:norm! ]] .. opts.args)
    end
  end
end, { nargs = 1, count = 1 })

vim.api.nvim_create_user_command("AnsibleLintFix", function()
  local Job = require("plenary.job")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  Job:new({
    command = "ansible-lint",
    args = { "--fix", "-L", "-x", "role-name", "--nocolor" },
    on_exit = function(j, _)
      vim.schedule(function()
        if j.code ~= 0 then
          vim.notify(vim.inspect(j._stderr_results), vim.log.levels.ERROR)
          return
        end
        local result_list = {}
        for _, v in pairs(j:result()) do
          table.insert(result_list, v)
        end
        require("telescope.pickers")
            .new({}, {
              prompt_title = "Ansible Lint Fix",
              finder = require("telescope.finders").new_table({
                results = result_list,
              }),
              attach_mappings = function(prompt_bufnr, _)
                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  local selection = action_state.get_selected_entry()
                  local fix = string.match(selection[1], "(%w+).+")
                  vim.cmd("wa")
                  Job:new({
                    command = "ansible-lint",
                    args = { "--nocolor", "-x", "role-name", "--fix", fix, vim.api.nvim_buf_get_name(0) },
                    stdin = function()
                      local content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
                      return table.concat(content, "\n")
                    end,
                    on_exit = function(k, _)
                      vim.schedule(function()
                        if k.code ~= 0 then
                          vim.notify(vim.inspect(j._stderr_results))
                        end
                      end)
                    end,
                  }):start()
                end)
                return true
              end,
              sorter = require("telescope.config").values.generic_sorter({}),
            })
            :find()
      end)
    end,
  }):sync()
end, {})

vim.api.nvim_create_user_command("InsertJiraTag", function()
  local branch_tag = get_jira_tag()
  local buf_text = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local found = false
  if not branch_tag then
    return
  end
  for _, text in pairs(buf_text) do
    -- ignore comments
    if string.find(text, "#.+") == nil then
      -- preform search for jira tag
      local search_check = string.find(text, branch_tag, 1, true)
      if search_check then
        found = true
      end
    end
  end
  if not found then
    vim.api.nvim_win_set_cursor(0, { 1, branch_tag:len() + 2 })
    vim.cmd([[:call feedkeys('A', 'n')]])
    branch_tag = branch_tag .. " "
    vim.api.nvim_buf_set_text(0, 0, 0, 0, 0, { branch_tag })
  end
end, {})

vim.api.nvim_create_user_command("OrgModeTODO", function()
  local orgmode = require("orgmode.files"):new({ paths = { "~/notes/**/*" } })
  local files = orgmode:load_sync(true, 20000)
  local output = ""
  for _, orgfile in pairs(files.all_files) do
    for _, headline in ipairs(orgfile:get_opened_unfinished_headlines()) do
      for _, date in ipairs(headline:get_deadline_and_scheduled_dates()) do
        local title = headline:get_headline_line_content()
        if string.match(title, ".*TODO.*") then
          local date_string = ("%s-%s-%s"):format(date.year, date.month, date.day)
          output = output .. ("\n%s: %s"):format(title, date_string)
        end
      end
    end
  end
  local title = "Agenda Items in TODO:"
  if output == "" then
    return
  end
  vim.print(title .. output)
  if vim.fn.executable('notify-send') == 1 then
    vim.system({
      'notify-send',
      ('--icon=~/.local/share/nvim/lazy/orgmode/assets/nvim-orgmode-small.png'),
      '--app-name=orgmode',
      title,
      output,
    })
  end

  if vim.fn.executable('terminal-notifier') == 1 then
    vim.system({ 'terminal-notifier', '-title', title, '-message', output })
  end
  if #vim.api.nvim_list_uis() == 0 then
    vim.cmd([[qall!]])
  end
end, {})

-- Workaround for getting terraform-ls errors when opening up tfvars file
vim.filetype.add({
  extension = {
    tfvars = "hcl",
  },
})

vim.api.nvim_create_user_command("WipeWindowlessBufs", function()
  local bufinfos = vim.fn.getbufinfo({ buflisted = true })
  vim.tbl_map(function(bufinfo)
    if bufinfo.changed == 0 and (not bufinfo.windows or #bufinfo.windows == 0) then
      print(("Deleting buffer %d : %s"):format(bufinfo.bufnr, bufinfo.name))
      vim.api.nvim_buf_delete(bufinfo.bufnr, { force = false, unload = false })
    end
  end, bufinfos)
end, { desc = "Wipeout all buffers not shown in a window" })

vim.api.nvim_create_user_command("JiraNewBranch", function()
  toggle_term("zsh -c 'new_jira_branch.sh || sleep 3'")
end, { desc = "Run new jira branch command in pop up terminal" })
