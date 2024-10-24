local custom_actions = {}

function custom_actions.fzf_multi_select(prompt_bufnr)
	local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
	local num_selections = table.getn(picker:get_multi_selection())

	if num_selections > 1 then
		require("telescope.actions").send_selected_to_qflist(prompt_bufnr)
		require("telescope.actions").open_qflist()
	else
		require("telescope.actions").file_edit(prompt_bufnr)
	end
end

return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {

			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-lua/popup.nvim" },
			{ "nvim-lua/plenary.nvim" },
			{ "debugloop/telescope-undo.nvim" },
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				config = function()
					require("telescope").load_extension("fzf")
					require("telescope").load_extension("undo")
				end,
			},
		},
		lazy = true,
		keymap = "<leader>",
		init = function()
			vim.keymap.set("n", "<leader><leader>", function()
				require("telescope.builtin").find_files({
					file_ignore_patterns = {
						"node%_modules/.*",
						"undodir/.*",
					},
					hidden = true,
				})
			end, { desc = "Find File" })

			vim.keymap.set("n", "<leader>/?", function()
				require("telescope.builtin").grep_string({
					only_sort_text = true,
				})
			end, { desc = "Grep Directory" })

			vim.keymap.set("n", "<leader>/f", function()
				require("telescope.builtin").treesitter()
				vim.cmd([[:norm zt]])
			end, { desc = "Treesitter" })

			vim.keymap.set("n", "<leader>/a", function()
				require("telescope.builtin").find_files({
					file_ignore_patterns = {
						"node%_modules/.*",
						"undodir/.*",
						".*venv/.*",
						".*.venv/.*",
						".*.npm/.*",
						".*__pycache__.*",
						".*.nox.*",
						".*.pytest_cache.*",
						".*.pdm.*",
						".*.cache.*",
					},
					no_ignore = true,
					no_ignore_parent = true,
					desc = "All Files",
				})
			end, { desc = "All Files" })

			vim.keymap.set("n", "<leader>/q", function()
				require("telescope.builtin").resume()
			end, { desc = "Telescope last search" })

			vim.keymap.set("n", "<leader>//", function()
				require("telescope.builtin").live_grep({
					only_sort_text = true,
				})
			end, { desc = "Live Grep Directory" })

			-- buffers
			vim.keymap.set("n", "<leader>bb", function()
				require("telescope.builtin").buffers()
			end, { desc = "List Buffers" })

			-- git
			vim.keymap.set("n", "<leader>gc", function()
				require("telescope.builtin").git_commits({
					prompt_title = "switch to commit",
				})
			end, { desc = "Search git commits" })

			vim.keymap.set("n", "<leader>gB", function()
				require("telescope.builtin").git_bcommits({
					prompt_title = "switch to commit on this buffer",
				})
			end, { desc = "Search git commits (buffer)" })

			vim.keymap.set("n", "<leader>gb", function()
				require("telescope.builtin").git_branches({})
			end, { desc = "Switch git branch" })

			vim.keymap.set("n", "<leader>ju", function()
				require("telescope").extensions.undo.undo({ side_by_side = true })
			end, { desc = "Telescope undotree" })
		end,
		config = function()
			local actions = require("telescope.actions")
			require("telescope").setup({
				extensions = {
					fzf = {
						fuzzy = true,                   -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true,    -- override the file sorter
						case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
					undo = {},
				},
				pickers = {
					live_grep = {
						additional_args = function()
							return { "-L" }
						end,
						mappings = {
							i = {
								["<cr>"] = custom_actions.fzf_multi_select,
							},
							n = {
								["<cr>"] = custom_actions.fzf_multi_select,
							},
						},
					},
					find_files = {
						previewer = false,
						find_command = { "rg", "--ignore", "-L", "--hidden", "--files", "--glob", "!.git" },
						mappings = {
							i = {
								["<cr>"] = custom_actions.fzf_multi_select,
							},
							n = {
								["<cr>"] = custom_actions.fzf_multi_select,
							},
						},
					},
					buffers = {
						previewer = false,
					},
				},
				defaults = {
					preview = {
						treesitter = false,
					},
					mappings = {
						i = {
							-- close on escape
							["<esc>"] = actions.close,
							["<tab>"] = actions.toggle_selection + actions.move_selection_next,
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
						},
						n = {
							["<tab>"] = actions.toggle_selection + actions.move_selection_next,
							["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
						},
					},
				},
			})
		end,
	},
}
