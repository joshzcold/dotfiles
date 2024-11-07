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
	leaderkey = " ",
	transparent = false,
	event = "UserGroup",
	config = {
		undodir = vim.fn.stdpath("cache") .. "/undo",
	},
}
-- Global user group to register other custom autocmds
vim.api.nvim_create_augroup(vim.g.user.event, {})

vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
	callback = function()
		vim.cmd([[:syntax sync fromstart]])
	end,
})

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
vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.g.user.event,
	callback = function(args)
		local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line("$")
		local not_commit = vim.b[args.buf].filetype ~= "commit"

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
		map("n", "<leader>lay", "A # noqa yaml[line-length]<esc>")
		map(
			"v",
			"<leader>la{",
			[[:s/{{\(\w\+\)}}/{{ \1 }}/gc<cr>]],
			{ desc = "reformat put in space in ansible variable templates" }
		)
		map("n", "<leader>laf", "<cmd>AnsibleLintFix<cr>", { desc = "Ansible Lint Fix" })
		vim.opt_local.makeprg = "ansible-lint -p --nocolor"
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
		local pyproject_file = SearchUp("pyproject.toml")
		if not pyproject_file then
			vim.opt_local.makeprg = "ruff check --output-format=concise ."
		else
			vim.opt_local.makeprg = "ruff check --config=" .. pyproject_file .. " --output-format=concise ."
		end
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
	pattern = { "*.json", "*.jsonc" },
	callback = function()
		vim.opt_local.winbar = "%{%v:lua.require'jsonpath'.get()%}"
	end,
})

-- yaml
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "yaml", "yaml.ansible" },
	callback = function()
		vim.opt_local.winbar = "%{%v:lua.require'yaml_nvim'.get_yaml_key()%}"
	end,
})

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), "info", {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})
