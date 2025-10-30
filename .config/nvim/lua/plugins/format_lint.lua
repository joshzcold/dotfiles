return {
  {

    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        groovy = { "npm-groovy-lint" },
        Jenkinsfile = { "npm-groovy-lint" },
        ["yaml.ansible"] = { "ansible_lint" },
        zsh = { "zsh" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
        callback = function()
          -- try_lint without arguments runs the linters defined in `linters_by_ft`
          -- for the current filetype
          require("lint").try_lint()

          -- You can call `try_lint` with a linter name or a list of names to always
          -- run specific linters, independent of the `linters_by_ft` configuration
          -- require("lint").try_lint("cspell")
        end,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>=",
        function()
          vim.notify("Running formatters...", vim.log.levels.DEBUG)
          require("conform").format({ async = true }, function(err)
            if not err then
              local mode = vim.api.nvim_get_mode().mode
              if vim.startswith(string.lower(mode), "v") then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
              end
            end
          end)
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "ruff_format", "isort", "black", stop_after_first = true },
        -- You can customize some of the format options for the filetype (:help conform.format)
        rust = { "rustfmt" },
        -- Conform will run the first available formatter
        javascript = { "prettierd", "prettier", stop_after_first = true },
        sh = { "shfmt" },
        groovy = { "npm-groovy-lint" },
        go = { "goimports", "gofmt" },
        Jenkinsfile = { "npm-groovy-lint" },
        terraform = { "terraform_fmt" },
        ["yaml.ansible"] = { "ansible-lint", "prettierd" },
        -- Use the "*" filetype to run formatters on all filetypes.
        ["*"] = { "codespell" },
        -- Use the "_" filetype to run formatters on filetypes that don't
        -- have other formatters configured.
        ["_"] = { "trim_whitespace" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
  },
  -- {
  --
  --   "nvimtools/none-ls.nvim",
  --   enabled = false,
  --   config = function()
  --     -- Here is the formatting config
  --     local null_ls = require("null-ls")
  --     local git_cmd = vim.fn.system("git rev-parse --show-toplevel | tr -d '\n'")
  --     local lSsources = {
  --       null_ls.builtins.formatting.prettierd.with({
  --         extra_filetypes = { "yaml.ansible", "markdown" },
  --       }),
  --
  --       null_ls.builtins.formatting.nginx_beautifier.with({
  --         args = { "-s", "4", "-i", "-o", "$FILENAME" },
  --         filetypes = {
  --           "nginx",
  --           "conf",
  --         },
  --       }),
  --       null_ls.builtins.formatting.shfmt,
  --       -- python
  --       -- null_ls.builtins.formatting.black,
  --       -- null_ls.builtins.formatting.isort,
  --     }
  --     if vim.fn.filereadable(git_cmd .. "/.groovylintrc.json") ~= 1 then
  --       -- null ls sources only if you aren't in a git repo
  --       table.insert(
  --         lSsources,
  --         null_ls.builtins.diagnostics.npm_groovy_lint.with({
  --           args = { "-o", "json", "--config", os.getenv("HOME") .. "/.config/groovylint/groovylint.json", "-" },
  --           filetypes = {
  --             "Jenkinsfile",
  --             "groovy",
  --           },
  --         })
  --       )
  --       table.insert(
  --         lSsources,
  --         null_ls.builtins.formatting.npm_groovy_lint.with({
  --           args = {
  --             "--format",
  --             "--failon",
  --             "none",
  --             "--config",
  --             os.getenv("HOME") .. "/.config/groovylint/groovylint.json",
  --             "-",
  --           },
  --           filetypes = {
  --             "Jenkinsfile",
  --             "groovy",
  --           },
  --         })
  --       )
  --     else
  --       -- your in a git directory
  --       table.insert(
  --         lSsources,
  --         null_ls.builtins.diagnostics.npm_groovy_lint.with({
  --           filetypes = {
  --             "Jenkinsfile",
  --             "groovy",
  --           },
  --         })
  --       )
  --       table.insert(
  --         lSsources,
  --         null_ls.builtins.formatting.npm_groovy_lint.with({
  --           args = {
  --             "--format",
  --             "--failon",
  --             "none",
  --             "-",
  --           },
  --           filetypes = {
  --             "Jenkinsfile",
  --             "groovy",
  --           },
  --         })
  --       )
  --     end
  --     null_ls.setup({
  --       sources = lSsources,
  --     })
  --     vim.o.updatetime = 250
  --   end,
  -- }
}
