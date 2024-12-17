return {
  "folke/which-key.nvim",
  config = function()
    require("which-key").setup({
      plugins = {
        marks = true,       -- shows a list of your marks on ' and `
        registers = true,   -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
          enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
          operators = true,    -- adds help for operators like d, y, ... And registers them for motion / text object completion
          motions = true,      -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true,      -- default bindings on <c-w>
          nav = true,          -- misc bindings to work with windows
          z = true,            -- bindings for folds, spelling and others prefixed with z
          g = true,            -- bindings for prefixed with g
        },
      },
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3,                    -- spacing between columns
        align = "left",                 -- align columns left, center or right
      },
      show_help = true,                 -- show help message on the command line when the popup is visible
      triggers = {
        { "<leader>", mode = { "n", "v" } },
      },
      -- triggers = {"<leader>"} -- or specify a list manually
    })

    local wk = require("which-key")
    wk.add({
      {
        { "<leader>/",  group = "Find" },
        { "<leader>b",  group = "Buffers" },
        { "<leader>d",  group = "Debug" },
        { "<leader>da", group = "Control" },
        { "<leader>db", group = "Breakpoints" },
        { "<leader>dh", group = "Hover" },
        { "<leader>dr", group = "Repl" },
        { "<leader>ds", group = "Step" },
        { "<leader>du", group = "UI" },
        { "<leader>f",  group = "Jump" },
        { "<leader>g",  group = "Git" },
        { "<leader>j",  group = "Misc" },
        { "<leader>jj", group = "Jira Actions" },
        { "<leader>s",  group = "Substitute" },
        { "<leader>t",  group = "Terminal" },
        { "<leader>v",  group = "Vim" },
        { "<leader>vp", group = "Profile vim" },
        { "<leader>y",  group = "Yank" },
      },
    }, { prefix = "<leader>" })
  end,
}
