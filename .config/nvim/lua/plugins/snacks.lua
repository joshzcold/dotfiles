---@module 'snacks'
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      quickfile = { enabled = true },
      statuscolumn = { enabled = false },
      words = { enabled = true },
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
      { "<leader>bd",      function() Snacks.bufdelete() end,                    desc = "Delete Buffer", },
      { "<leader><space>", function() Snacks.picker.files() end,                 desc = "Find Files" },
      { "<leader>bb",      function() Snacks.picker.buffers() end,               desc = "Buffers" },
      { "<leader>//",      function() Snacks.picker.grep() end,                  desc = "Grep" },
      { "<leader>/:",      function() Snacks.picker.command_history() end,       desc = "Command History" },
      { "<leader>/n",      function() Snacks.picker.notifications() end,         desc = "Notification History" },
      { "<leader>/e",      function() Snacks.explorer() end,                     desc = "File Explorer" },
      { "<leader>/q",      function() Snacks.picker.search_history() end,        desc = "File Explorer" },
      -- LSP
      { "gd",              function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
      { "gD",              function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
      { "gr",              function() Snacks.picker.lsp_references() end,        nowait = true,                     desc = "References" },
      { "gI",              function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
      { "gy",              function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
      { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
      { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      -- Other
      { "<leader>z",       function() Snacks.zen() end,                          desc = "Toggle Zen Mode" },
      { "<leader>Z",       function() Snacks.zen.zoom() end,                     desc = "Toggle Zoom" },
      { "<leader>.",       function() Snacks.scratch() end,                      desc = "Toggle Scratch Buffer" },
      { "<leader>S",       function() Snacks.scratch.select() end,               desc = "Select Scratch Buffer" },
      { "<leader>n",       function() Snacks.notifier.show_history() end,        desc = "Notification History" },
      { "<leader>bd",      function() Snacks.bufdelete() end,                    desc = "Delete Buffer" },
      { "<leader>cR",      function() Snacks.rename.rename_file() end,           desc = "Rename File" },
      { "<leader>gB",      function() Snacks.gitbrowse() end,                    desc = "Git Browse",               mode = { "n", "v" } },
      { "<leader>un",      function() Snacks.notifier.hide() end,                desc = "Dismiss All Notifications" },

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

          -- Create some toggle mappings fjdkslfd
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
