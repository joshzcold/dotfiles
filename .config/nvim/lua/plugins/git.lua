return {
  {
    "tpope/vim-fugitive",
    lazy = true,
    cmd = { "Git" },
    init = function()
      vim.keymap.set("n", "<leader>gg", function()
        vim.cmd([[:Git<cr>]])
      end, { desc = "Git" })
    end,
    config = function()
      --Use q to quit from fugituve
      vim.cmd([[au FileType fugitive nnoremap <silent> <buffer> q :norm gq<cr>]])
    end,
  }, -- Git commands in nvim
  {
    "sindrets/diffview.nvim",
    lazy = true,
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewOpen" },
    init = function()
      vim.keymap.set("n", "<leader>gd", function()
        vim.cmd([[:DiffviewOpen<cr>]])
      end, { desc = "Git diff" })

      vim.keymap.set("n", "<leader>gm", function()
        vim.cmd([[:DiffviewOpen master<cr>]])
      end, { desc = "Git diff (master)" })

      vim.keymap.set("n", "<leader>gk", function()
        vim.cmd([[:DiffviewClose<cr>]])
      end, { desc = "Git diff close" })
    end,
  },
  -- Add git related info in the signs columns and popups
  {
    "lewis6991/gitsigns.nvim",
    init = function()
      vim.keymap.set("n", "<leader>gx", function()
        vim.cmd([[:Gitsigns reset_hunk<cr>]])
      end, { desc = "Undo git hunk at point" })

      vim.keymap.set("n", "<leader>gn", function()
        vim.cmd([[:Gitsigns next_hunk<cr>]])
      end, { desc = "Move to next git hunk" })
    end,
    config = function()
      require("gitsigns").setup()
    end,
  },
  {
    "ruifm/gitlinker.nvim",
    init = function()
      vim.keymap.set("n", "<leader>gb", function()
        require"gitlinker".get_buf_range_url('n')
      end, { desc = "Create git link" })
    end,
    config = function()
      require("gitlinker").setup({
        opts = {
          remote = nil, -- force the use of a specific remote
          -- adds current line nr in the url for normal mode
          add_current_line_on_normal_mode = true,
          -- callback for what to do with the url
          action_callback = require("gitlinker.actions").copy_to_clipboard,
          -- print the url after performing the action
          print_url = true,
        },
        callbacks = {
          ["bitbucket.secmet.co"] = function(url_data)
            local project, repo = string.match(url_data.repo, "(%w+)/(.*)")
            local url = "https://"
              .. url_data.host
              .. "/projects/"
              .. project
              .. "/repos/"
              .. repo
              .. "/browse/"
              .. url_data.file
              .. "?at="
              .. url_data.rev
            if url_data.lstart then
              url = url .. "#" .. url_data.lstart
            end
            return url
          end,
        },
      })
    end,
  },
}
