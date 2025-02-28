---@module 'snacks'
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    enabled = true,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = {},
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      quickfile = {},
      statuscolumn = {},
      input = { enabled = false },
      words = {},
      picker = {
        win = {
          list = { keys = { ["<c-x>"] = { "edit_split", mode = { "i", "n" } } } },
          input = { keys = { ["<c-x>"] = { "edit_split", mode = { "i", "n" } } } },
        },
      },
      styles = {},
    },
    -- stylua: ignore
    keys = {
      { "<leader><space>", function() Snacks.picker.files() end,                                   desc = "Find Files" },
      { "<leader>/v",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>/b",      function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
      { "<leader>bb",      function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
      { "<leader>//",      function() Snacks.picker.grep() end,                                    desc = "Grep" },
      { "<leader>/:",      function() Snacks.picker.command_history() end,                         desc = "Command History" },
      { "<leader>/h",      function() Snacks.picker.help() end,                         desc = "Neovim Help Docs" },
      { "<leader>/n",      function() Snacks.picker.notifications() end,                           desc = "Notification History" },
      { "<leader>/e",      function() Snacks.explorer() end,                                       desc = "File Explorer" },
      { "<leader>/q",      function() Snacks.picker.resume() end,                                  desc = "Resume search" },
      { "<leader>ju",      function() Snacks.picker.undo() end,                                    desc = "Undo history" },
      { "<leader>/u",      function() Snacks.picker.undo() end,                                    desc = "Undo history" },
      { "<leader>/i",      function() Snacks.picker.icons() end,                                   desc = "Icons" },
      { "<leader>/d",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
      { "<leader>/D",      function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
      -- git
      { "<leader>gb",      function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
      { "<leader>gl",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
      { "<leader>gL",      function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
      { "<leader>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
      { "<leader>gS",      function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
      { "<leader>gd",      function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
      { "<leader>gf",      function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },

      -- LSP
      { "gd",              function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
      { "gD",              function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
      { "gr",              function() Snacks.picker.lsp_references() end,                          nowait = true,                     desc = "References" },
      { "gI",              function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
      { "gy",              function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
      { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
      { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },
      -- Other
      { "<leader>z",       function() Snacks.zen() end,                                            desc = "Toggle Zen Mode" },
      { "<leader>Z",       function() Snacks.zen.zoom() end,                                       desc = "Toggle Zoom" },
      { "<leader>.",       function() Snacks.scratch() end,                                        desc = "Toggle Scratch Buffer" },
      { "<leader>S",       function() Snacks.scratch.select() end,                                 desc = "Select Scratch Buffer" },
      { "<leader>n",       function() Snacks.notifier.show_history() end,                          desc = "Notification History" },
      { "<leader>bd",      function() Snacks.bufdelete() end,                                      desc = "Delete Buffer" },
      { "<leader>cR",      function() Snacks.rename.rename_file() end,                             desc = "Rename File" },
      { "<leader>gB",      function() Snacks.gitbrowse() end,                                      desc = "Git Browse",               mode = { "n", "v" } },
      { "<leader>un",      function() Snacks.notifier.hide() end,                                  desc = "Dismiss All Notifications" },

    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle
              .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
              :map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          vim.api.nvim_create_user_command("Notifications", function()
            Snacks.notifier.show_history()
          end, {})
        end,
      })
    end,
  },
}
