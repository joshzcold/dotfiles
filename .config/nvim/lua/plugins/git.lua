return {
  {
    "tpope/vim-fugitive",
    lazy = false,
    cmd = { "Git" },
    init = function()
      vim.keymap.set("n", "<leader>gg", function()
        vim.cmd([[:Git]])
      end, { desc = "Git" })
      vim.keymap.set("n", "<leader>gp", function()
        vim.cmd("Git push")
      end, { desc = "Git push" })

      vim.keymap.set("n", "<leader>gR", function()
        vim.cmd("Git fetch origin")
        vim.cmd("Git rebase -i origin/master")
      end, { desc = "Git rebase with origin/master" })
    end,
    config = function()
      vim.cmd([[au FileType fugitive nnoremap <silent> <buffer> q :norm gq<cr>]])

      -- :git (lowercase) expands to :Git in command mode
      vim.cmd("cnoreabbrev git Git")

      -- Override :Git with a smart router: terminal for subcommands that need a TTY,
      -- passthrough to fugitive#Command for everything else.
      local tty_subcmds = { push = true, pull = true, fetch = true }
      vim.api.nvim_create_user_command("Git", function(opts)
        local subcmd = (opts.args:match("^(%S+)") or ""):lower()
        if tty_subcmds[subcmd] then
          vim.cmd("split | terminal git " .. opts.args)
          vim.cmd("startinsert")
        else
          local cmd = vim.fn["fugitive#Command"](opts.line1, opts.count, opts.range, opts.bang and 1 or 0, opts.mods, opts.args)
          vim.cmd(cmd)
        end
      end, {
        nargs = "*",
        bang = true,
        range = -1,
        force = true,
        complete = function(arglead, cmdline, cursorpos)
          return vim.fn["fugitive#Complete"](arglead, cmdline, cursorpos)
        end,
        desc = "Git",
      })
    end,
  }, -- Git commands in nvim
  {
    "sindrets/diffview.nvim",
    lazy = true,
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewOpen" },
    init = function()
      vim.keymap.set("n", "<leader>gd", function()
        if vim.bo.filetype == "DiffviewFiles" then
          vim.cmd([[:DiffviewClose]])
        else
          vim.cmd([[:DiffviewOpen]])
        end
      end, { desc = "Git diff" })

      vim.keymap.set("n", "<leader>gm", function()
        if vim.bo.filetype == "DiffviewFiles" then
          vim.cmd([[:DiffviewClose]])
        else
          vim.cmd([[!git fetch origin]])
          vim.cmd([[:DiffviewOpen origin/master]])
        end
      end, { desc = "Git diff (master)" })

      vim.keymap.set("n", "<leader>gq", function()
        vim.cmd([[:DiffviewClose]])
      end, { desc = "Git diff close" })
    end,
  },
  -- Add git related info in the signs columns and popups
  {
    "echasnovski/mini.diff",
    enabled = true,
    opts = {
      view = {
        style = "sign",
        signs = { add = "+", change = "~", delete = "-" },
      },
    },
    init = function()
      vim.keymap.set("n", "<leader>gx", function()
        return MiniDiff.operator("reset") .. "gh"
      end, { desc = "Undo git hunk at point", expr = true, remap = true })

      vim.keymap.set("n", "<leader>gn", function()
        MiniDiff.goto_hunk("next", {})
      end, { desc = "Move to next git hunk" })

      vim.keymap.set("n", "<leader>gj", function()
        MiniDiff.goto_hunk("next", {})
      end, { desc = "Move to next git hunk" })

      vim.keymap.set("n", "<leader>gk", function()
        MiniDiff.goto_hunk("prev", {})
      end, { desc = "Move to next git hunk" })
    end,
  },
  {
    "ruifm/gitlinker.nvim",
    init = function()
      vim.keymap.set("n", "<leader>gb", function()
        require("gitlinker").get_buf_range_url("n")
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
