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
            branch_tag = branch_tag.." "
						local row, col = unpack(vim.api.nvim_win_get_cursor(0))
						vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { branch_tag })
						print(branch_tag:len())
						vim.api.nvim_win_set_cursor(0, { 1, branch_tag:len() + 2 })
            vim.cmd[[:call feedkeys('A', 'n')]]
					end
				end
			end)
		end,
	}):sync()
end, {})
