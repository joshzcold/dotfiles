return {
	{
		"mhartington/formatter.nvim",
		config = function()
			local function groovy_format()
				return {
					exe = "/home/joshua/.nvm/versions/node/v16.20.2/bin/npm-groovy-lint",
					args = {
						"--serverhost http://127.0.0.1",
						"--format",
						"--javaexecutable /usr/lib/jvm/java-11-openjdk/bin/java",
						"--failon",
						"none",
						"-",
					},
					stdin = true,
				}
			end
            local function nginx_format()
                return {
                    exe = "nginxbeautifier",
                    args = {
                        "--space 4",
                        "--blank-lines",
                    },
                    stdin = false
                }
            end
			vim.keymap.set("n", "<leader>=", "<cmd>Format<cr>", { desc = "LSP Format" })
			require("formatter").setup({
				logging = true,
				log_level = vim.log.levels.DEBUG,
				filetype = {
					lua = {
						require("formatter.filetypes.lua").stylua,
					},
					python = {
						require("formatter.filetypes.python").autopep8({
							args = { "--max-line-length", "120", "-" },
						}),
						require("formatter.filetypes.python").black({
							args = { "--line-length", "120", "-" },
						}),
					},
					javascript = {
						require("formatter.filetypes.javascript").prettierd,
					},
					Jenkinsfile = {
						groovy_format,
					},
					groovy = {
						groovy_format,
					},
					nginx = {
						nginx_format,
					},
					javascriptreact = {
						require("formatter.filetypes.javascriptreact").prettierd,
					},
					typescript = {
						require("formatter.filetypes.typescript").prettierd,
					},
					markdown = {
						require("formatter.filetypes.markdown").prettierd,
					},
					json = {
						require("formatter.filetypes.json").jq,
					},
					sh = {
						require("formatter.filetypes.sh").shfmt,
					},
					["*"] = {
						require("formatter.filetypes.any").remove_trailing_whitespace,
					},
				},
			})
		end,
	},
}
