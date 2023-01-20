return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      -- Here is the formatting config
      local null_ls = require("null-ls")
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
      }
      require("null-ls").setup({
        sources = lSsources,
      })
      -- the duration in there is to stop timeouts on massive files
      -- vim.cmd("autocmd BufWritePre * lua vim.lsp.buf.formatting_seq_sync(nil, 7500)")
      vim.o.updatetime = 250
    end,
  },
}