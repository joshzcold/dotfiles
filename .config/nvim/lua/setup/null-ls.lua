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
  null_ls.builtins.formatting.nginx_beautifier,
  null_ls.builtins.formatting.shfmt,
  null_ls.builtins.diagnostics.ansiblelint.with({
    filetypes = { "yaml.ansible" },
    args = { "-f", "codeclimate", "-q", "--exclude", ".roles", "--nocolor", "$FILENAME" },
  }),
}
require("null-ls").setup({
  sources = lSsources
})
-- the duration in there is to stop timeouts on massive files
-- vim.cmd("autocmd BufWritePre * lua vim.lsp.buf.formatting_seq_sync(nil, 7500)")
vim.o.updatetime = 250
