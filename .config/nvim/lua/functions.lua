local function git_write_with_input()
      vim.cmd.Gwrite()
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
                  end)
            end,
      }):sync()
end, {})
