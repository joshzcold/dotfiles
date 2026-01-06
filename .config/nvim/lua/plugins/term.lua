return {
  {
    "akinsho/toggleterm.nvim",
    init = function()
      --[[
			--	Set up lots of key bindings to support up to 9 terminals at once
			--]]
      for i = 9, 1, -1 do
        local n = i
        if i == 1 then
          ---@diagnostic disable-next-line: cast-local-type
          i = ""
        end
        vim.keymap.set("n", "<leader>t" .. i .. "t", function()
          vim.cmd(":" .. n .. "ToggleTerm size=10 direction=tab")
        end, { desc = "Term Tab " .. i })

        vim.keymap.set("n", "<leader>t" .. i .. "l", function()
          local width = vim.o.columns
          local set_width = width / 3
          vim.cmd(":" .. n .. "ToggleTerm size=" .. set_width .. " direction=vertical")
        end, { desc = "Term Right " .. i })

        vim.keymap.set("n", "<leader>t" .. i .. "j", function()
          vim.cmd(":" .. n .. "ToggleTerm size=10 direction=horizontal")
        end, { desc = "Term Below " .. i })

        vim.keymap.set("n", "<leader>t" .. i .. "k", function()
          vim.cmd(":" .. n .. "ToggleTerm size=10 direction=float")
        end, { desc = "Term Float " .. i })
      end
      vim.keymap.set("n", "<leader>tx", function()
        vim.cmd([[:ToggleTermToggleAll]])
      end, { desc = "Term Toggle All" })

      vim.keymap.set("n", "<leader>t<leader>", function()
        vim.cmd([[:TermSelect]])
      end, { desc = "Term Select" })

      -- misc keymappings jira
      vim.keymap.set("n", "<leader>jb", function()
        vim.cmd([[:JiraNewBranch]])
      end, { desc = "New Jira Branch" })
      vim.keymap.set("n", "<leader>jjn", function()
        toggle_term("Jira Issue Create", "jira issue create")
      end, { desc = "New Jira issue" })
      vim.keymap.set("n", "<leader>jjc", function()
        toggle_term("Jira Add Comment", "jira-add-comment")
      end, { desc = "New Jira comment" })
      vim.keymap.set("n", "<leader>jjm", function()
        toggle_term("Jira Add Comment", "jira-add-comment")
      end, { desc = "Move Jira issue" })
      vim.keymap.set("n", "<leader>jjv", function()
        toggle_term("Jira View Issue", "jira-view-issue")
      end, { desc = "View Jira Issue" })

      -- lazy git
      vim.keymap.set("n", "<leader>gl", function()
        toggle_term("LazyGit", "lazygit")
      end, { desc = "Open Lazy Git" })
    end,
    config = function()
      require("toggleterm").setup({
        start_in_insert = true,
        auto_scroll = false,
      })
      vim.cmd([[ au TermOpen * setlocal nospell ]])
    end,
  },
}
