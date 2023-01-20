return {
  {
    "kyazdani42/nvim-tree.lua",
    dependencies = {
      { "kyazdani42/nvim-web-devicons" },
    },
    init = function()
      vim.keymap.set("n", "<leader>/e", function()
        vim.cmd([[:NvimTreeToggle]])
      end, { desc = "Open nvim-tree" })
    end,
    config = function()
      local tree_cb = require("nvim-tree.config").nvim_tree_callback
      require("nvim-tree").setup({
        disable_netrw = true,
        update_cwd = true,
        view = {
          width = 50,
          mappings = {
            list = {
              { key = { "<CR>", "o", "<2-LeftMouse>", "l" }, cb = tree_cb("edit") },
              -- { key = { "<2-RightMouse>", "<C-]>" }, cb = tree_cb("cd") },
              -- { key = "<C-v>", cb = tree_cb("vsplit") },
              -- { key = "<C-x>", cb = tree_cb("split") },
              -- { key = "<C-t>", cb = tree_cb("tabnew") },
              -- { key = "<", cb = tree_cb("prev_sibling") },
              -- { key = ">", cb = tree_cb("next_sibling") },
              -- { key = "P", cb = tree_cb("parent_node") },
              { key = { "<BS>", "h" }, cb = tree_cb("close_node") },
              -- { key = "<S-CR>", cb = tree_cb("close_node") },
              -- { key = "<Tab>", cb = tree_cb("preview") },
              -- { key = "K", cb = tree_cb("first_sibling") },
              -- { key = "J", cb = tree_cb("last_sibling") },
              -- { key = "I", cb = tree_cb("toggle_ignored") },
              -- { key = "H", cb = tree_cb("toggle_dotfiles") },
              -- { key = "R", cb = tree_cb("refresh") },
              -- { key = "a", cb = tree_cb("create") },
              { key = "df", cb = tree_cb("remove") },
              -- { key = "dd", cb = tree_cb("cut") },
              -- { key = "r", cb = tree_cb("rename") },
              -- { key = "<C-r>", cb = tree_cb("full_rename") },
              -- { key = "x", cb = tree_cb("cut") },
              -- { key = "c", cb = tree_cb("copy") },
              -- { key = "p", cb = tree_cb("paste") },
              -- { key = "y", cb = tree_cb("copy_name") },
              -- { key = "Y", cb = tree_cb("copy_path") },
              -- { key = "gy", cb = tree_cb("copy_absolute_path") },
              -- { key = "[c", cb = tree_cb("prev_git_item") },
              -- { key = "]c", cb = tree_cb("next_git_item") },
              -- { key = "-", cb = tree_cb("dir_up") },
              -- { key = "q", cb = tree_cb("close") },
              -- { key = "?", cb = tree_cb("toggle_help") },
            },
          },
        },
      })
    end,
  },
}