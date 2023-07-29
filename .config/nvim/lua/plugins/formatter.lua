return {
	{
		"mhartington/formatter.nvim",
		config = function()
			vim.keymap.set("n", "<leader>=", "<cmd>Format<cr>", { desc = "LSP Format" })
			require("formatter").setup({
				logging = true,
				log_level = vim.log.levels.WARN,
				filetype = {
					lua = {
						require("formatter.filetypes.lua").stylua,
					},
					python = {
						require("formatter.filetypes.python").autopep8({
							args = { "--max-line-length", "120", "-" },
						}),
					},
					javascript = {
						require("formatter.filetypes.javascript").prettierd,
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
