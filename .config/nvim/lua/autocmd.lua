local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.api.nvim_create_autocmd({ "TermOpen" }, {
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
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
		vim.opt_local.makeprg = "pylama --format pylint"
	end,
})

-- git
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "commitmsg" },
	callback = function()
		map("n", "<leader>a", "<cmd>AnsibleRequirementsBumpGitCommit<cr>", { desc = "Ansible insert new role bumps" })
	end,
})

-- groovy, jenkins pipelines
vim.api.nvim_create_autocmd({ "BufRead" }, {
	pattern = { "*.groovy" },
	callback = function()
		if vim.fn.search("pipeline", "nw") > 0 then
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
	pattern = { "yaml" },
	callback = function()
  	vim.opt_local.winbar = "%{%v:lua.require'yaml_nvim'.get()%}"
	end,
})
