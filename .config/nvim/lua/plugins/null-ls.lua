return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      -- Here is the formatting config
      local null_ls = require("null-ls")
      local git_cmd = vim.fn.system("git rev-parse --show-toplevel | tr -d '\n'")
      local lSsources = {
        null_ls.builtins.formatting.prettierd.with({
          filetypes = {
            "javascript",
            "typescript",
            "css",
            "scss",
            "html",
            "json",
            "yaml",
            "markdown",
            "graphql",
            "md",
            "txt",
          },
        }),
        null_ls.builtins.formatting.stylua.with({
          args = { "--indent-width", "2", "--indent-type", "Spaces", "-" },
        }),
        null_ls.builtins.formatting.autopep8.with({
          args = { "--max-line-length", "120", "-" },
        }),
        null_ls.builtins.formatting.nginx_beautifier.with({
          args = { "-s", "4", "-i", "-o", "$FILENAME" },
          filetypes = {
            "nginx",
            "conf",
          },
        }),
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.diagnostics.pylama.with({
          args = { "--from-stdin", "$FILENAME", "-f", "json", "--max-line-length", "120" },
        }),
      }

      if vim.fn.filereadable(git_cmd .. "/.groovylintrc.json") ~= 1 then
        -- null ls sources only if you aren't in a git repo
        table.insert(
          lSsources,
          null_ls.builtins.diagnostics.npm_groovy_lint.with({
            env = {
              PATH = "/home/joshua/.nvm/versions/node/v12.22.12/bin"
            },
            args = { "-o", "json", "--config", os.getenv("HOME") .. "/.config/groovylint/groovylint.json", "-" },
          })
        )
        table.insert(
          lSsources,
          null_ls.builtins.formatting.npm_groovy_lint.with({
            env = {
              PATH = "/home/joshua/.nvm/versions/node/v12.22.12/bin"
            },
            args = {
              "--format",
              "--failon",
              "none",
              "--config",
              os.getenv("HOME") .. "/.config/groovylint/groovylint.json",
              "-",
            },
          })
        )
      else
        -- your in a git directory
        table.insert(
          lSsources,
          null_ls.builtins.diagnostics.npm_groovy_lint.with({
            env = {
              PATH = "/home/joshua/.nvm/versions/node/v12.22.12/bin"
            },
          })
        )
        table.insert(
          lSsources,
          null_ls.builtins.formatting.npm_groovy_lint.with({
            env = {
              PATH = "/home/joshua/.nvm/versions/node/v12.22.12/bin"
            },
            args = {
              "--format",
              "--failon",
              "none",
              "-",
            },
          })
        )
      end
      -- require("null-ls").setup({
      --   sources = lSsources,
      --   debug = true,
      -- })
      -- the duration in there is to stop timeouts on massive files
      -- vim.cmd("autocmd BufWritePre * lua vim.lsp.buf.formatting_seq_sync(nil, 7500)")
      vim.o.updatetime = 250
    end,
  },
}
