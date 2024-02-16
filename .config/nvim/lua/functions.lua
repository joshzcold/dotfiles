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
  require("notify")("Pushed --> " .. message)
end, {})

vim.api.nvim_create_user_command("MoveWithJumpList", function(opts)
  print(vim.inspect(opts.args))
  local count = tonumber(vim.v.count)

  if count == 0 then
    vim.cmd([[:norm g]] .. opts.args)
  else
    if count > 0 then
      vim.cmd(":norm m'")
      for i = 1, count, 1 do
        vim.cmd([[:norm ]] .. opts.args)
      end
    else
      vim.cmd([[:norm ]] .. opts.args)
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
    on_exit = function(j, return_val)
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
              attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  local selection = action_state.get_selected_entry()
                  local fix = string.match(selection[1], "(%w+).+")
                  vim.cmd("wa")
                  Job:new({
                    command = "ansible-lint",
                    args = { "--nocolor", "-x", "role-name", "--fix", fix },
                    stdin = function()
                      local content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
                      return table.concat(content, "\n")
                    end,
                    on_exit = function(j, return_val)
                      vim.schedule(function()
                        if j.code ~= 0 then
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

vim.api.nvim_create_user_command("AnsibleRequirementsBumpGitCommit", function()
  local Job = require("plenary.job")
  Job:new({
    command = "git",
    args = { "diff", "--cached" },
    on_exit = function(j, return_val)
      local last_version = nil
      local result_list = {}
      for _, v in pairs(j:result()) do
        local version_pattern = "+%s+version:%s+(.+)"
        local name_pattern = "name:%s+(.+)"
        local _, _, version = string.find(v, version_pattern)
        local _, _, name = string.find(v, name_pattern)
        if version then
          last_version = version
        end
        if name then
          if last_version then
            table.insert(result_list, name .. " --> " .. last_version)
            last_version = nil
          end
        end
      end
      vim.schedule(function()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, result_list)
        vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { " bump ansible roles: " })
      end)
    end,
  }):sync()
end, {})

vim.api.nvim_create_user_command("InsertJiraTag", function()
  local Job = require("plenary.job")
  Job:new({
    command = "git",
    args = { "rev-parse", "--abbrev-ref", "HEAD" },
    on_exit = function(j, return_val)
      local patterns = {
        "(%a%w%d%-%d+)",
        "(ENHANCEMENT)",
        "(CHORE)",
      }
      vim.schedule(function()
        local buf_text = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        for _, p in ipairs(patterns) do
          local _, _, branch_tag = string.find(j:result()[1], p)
          local _, _, already_in = string.find(buf_text[1], p)

          if branch_tag and not already_in then
            branch_tag = branch_tag .. " "
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))
            vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { branch_tag })
            print(branch_tag:len())
            vim.api.nvim_win_set_cursor(0, { 1, branch_tag:len() + 2 })
            vim.cmd([[:call feedkeys('A', 'n')]])
          end
        end
      end)
    end,
  }):sync()
end, {})
