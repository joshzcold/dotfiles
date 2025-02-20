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
      },
      { "ANGkeith/telescope-terraform-doc.nvim" },
    },
    enabled = true,
    lazy = true,
    keymap = "<leader>",
    init = function()
      vim.keymap.set(
        "n",
        "<leader>/t",
        [[:Telescope terraform_doc full_name=hashicorp/aws<cr>]],
        { desc = "Terraform aws modules" }
      )
    end,
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
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
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("undo")
      require("telescope").load_extension("terraform_doc")
    end,
  },
}
