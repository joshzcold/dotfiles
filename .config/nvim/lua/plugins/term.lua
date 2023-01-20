return {
  {
    "akinsho/toggleterm.nvim",
    -- tag = "*",
    init = function()
      vim.keymap.set("n", "<leader>tt", function()
        vim.cmd([[:ToggleTerm size=10 direction=tab]])
      end, { desc = "Term Tab" })

      vim.keymap.set("n", "<leader>tl", function()
        local width = vim.fn.winwidth(0)
        local set_width = width / 3
        vim.cmd(":ToggleTerm size=" .. set_width .. " direction=vertical")
      end, { desc = "Term Right" })

      vim.keymap.set("n", "<leader>th", function()
        local width = vim.fn.winwidth(0)
        local set_width = width / 3
        vim.cmd(":ToggleTerm size=" .. set_width .. " direction=vertical")
      end, { desc = "Term Left" })

      vim.keymap.set("n", "<leader>tj", function()
        vim.cmd([[:ToggleTerm size=10 direction=horizontal]])
      end, { desc = "Term Below" })

      vim.keymap.set("n", "<leader>tk", function()
        vim.cmd([[:ToggleTerm direction=float]])
      end, { desc = "Term Float" })

      -- misc keymappings jira
      vim.keymap.set("n", "<leader>jjn", function()
        toggle_term("jira issue create")
      end, { desc = "New Jira issue" })
      vim.keymap.set("n", "<leader>jjc", function()
        toggle_term("jira-add-comment")
      end, { desc = "New Jira comment" })
      vim.keymap.set("n", "<leader>jjm", function()
        toggle_term("jira-add-comment")
      end, { desc = "Move Jira issue" })
      vim.keymap.set("n", "<leader>jjv", function()
        toggle_term("jira-view-issue")
      end, { desc = "View Jira Issue" })

      -- lazy git
      vim.keymap.set("n", "<leader>gl", function()
        toggle_term("lazygit")
      end, { desc = "Open Lazy Git" })
    end,
    config = function()
      require("toggleterm").setup({
        start_in_insert = false,
        auto_scroll = false,
      })
      vim.cmd([[
                au TermOpen * setlocal nospell
            ]])
    end,
  },
}
