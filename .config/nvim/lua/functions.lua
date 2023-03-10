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
