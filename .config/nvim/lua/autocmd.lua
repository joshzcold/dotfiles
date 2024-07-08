local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- User Config
-- ---
vim.g.user = {
  leaderkey = ' ',
  transparent = false,
  event = 'UserGroup',
  config = {
    undodir = vim.fn.stdpath('cache') .. '/undo',
  },
}
-- Global user group to register other custom autocmds
vim.api.nvim_create_augroup(vim.g.user.event, {})


vim.api.nvim_create_autocmd({ "TermOpen" }, {
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	end,
})

-- From vim defaults.vim
-- ---
-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler
-- (happens when dropping a file on gvim) and for a commit message (it's
-- likely a different one than last time).
vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.g.user.event,
  callback = function(args)
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
    local not_commit = vim.b[args.buf].filetype ~= 'commit'

    if valid_line and not_commit then
      vim.cmd([[normal! g`"]])
    end
  end,
})

-- Ansible
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "yaml.ansible", "yaml" },
	callback = function()
		map("n", "<leader>lab", "Iansible.builtin.<esc>")
		map(
			"v",
			"<leader>la{",
			[[:s/{{\(\w\+\)}}/{{ \1 }}/gc<cr>]],
			{ desc = "reformat put in space in ansible variable templates" }
		)
		map("n", "<leader>laf", "<cmd>AnsibleLintFix<cr>", { desc = "Ansible Lint Fix" })
		vim.opt_local.makeprg = "ansible-lint -p --nocolor -x role-name,package-latest,fqcn-builtins --exclude .roles"
		vim.opt_local.keywordprg = "ansible-doc"
	end,
})
-- set yaml.ansible file type based on search match
-- vim.api.nvim_create_autocmd({ "BufRead" }, {
--   pattern = { "*.yaml", "*.yml" },
--   callback = function()
--     if vim.fn.search([[\stasks:\|- name:]], "nw") > 0 then
--       vim.opt_local.ft = "yaml.ansible"
--     end
--   end,
-- })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*/playbooks/*.yml", "*/tasks/*.yml" },
	callback = function()
		vim.opt_local.ft = "yaml.ansible"
	end,
})

-- cloud init user-data is a yaml file
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "user-data", "meta-data" },
	callback = function()
		vim.opt_local.ft = "yaml"
	end,
})

-- Put in the jira tag in to the commit automatically
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "gitcommit" },
	callback = function()
		vim.cmd([[:InsertJiraTag]])
	end,
})

-- set nginx conf type base on search match
vim.api.nvim_create_autocmd({ "BufRead" }, {
	pattern = { "*.conf", "*.conf.*" },
	callback = function()
		if vim.fn.search([[http {\|server {]], "nw") > 0 then
			vim.opt_local.ft = "nginx"
		end
	end,
})

-- python
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "python" },
	callback = function()
		vim.opt_local.makeprg = "ruff check --output-format text ."
	end,
})

-- git
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "commitmsg", "gitcommit" },
	callback = function()
		map("n", "<leader>a", "<cmd>AnsibleRequirementsBumpGitCommit<cr>", { desc = "Ansible insert new role bumps" })
	end,
})

-- groovy, jenkins pipelines
vim.api.nvim_create_autocmd({ "BufRead" }, {
	pattern = { "*.groovy" },
	callback = function()
		if vim.fn.search("pipeline {", "nw") > 0 then
			vim.opt_local.ft = "Jenkinsfile"
			vim.opt_local.indentexpr = "GetJavascriptIndent()"
			vim.opt_local.makeprg = "jenkins-lint %"
		end
	end,
})

-- json
vim.api.nvim_create_autocmd({ "BufRead" }, {
	pattern = { "*.json", "*.jsonc"},
	callback = function()
  	vim.opt_local.winbar = "%{%v:lua.require'jsonpath'.get()%}"
	end,
})

-- yaml
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "yaml", "yaml.ansible"  },
	callback = function()
  	vim.opt_local.winbar = "%{%v:lua.require'yaml_nvim'.get_yaml_key()%}"
	end,
})
