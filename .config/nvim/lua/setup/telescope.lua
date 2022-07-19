-- Telescope
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local custom_actions = {}

function custom_actions.fzf_multi_select(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local num_selections = table.getn(picker:get_multi_selection())

  if num_selections > 1 then
    -- actions.file_edit throws - context of picker seems to change
    -- actions.file_edit(prompt_bufnr)
    actions.send_selected_to_qflist(prompt_bufnr)
    actions.open_qflist()
  else
    actions.file_edit(prompt_bufnr)
  end
end
require("telescope").setup({
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },
  pickers = {
    grep_string = {
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

require("telescope").load_extension("ui-select")
require("telescope").load_extension("fzf")
