return {
  "nvimtools/none-ls.nvim",
  config = function()
    -- Here is the formatting config
    local null_ls = require("null-ls")
    local git_cmd = vim.fn.system("git rev-parse --show-toplevel | tr -d '\n'")
    local lSsources = {
      null_ls.builtins.formatting.prettierd.with({
        extra_filetypes = { "yaml.ansible", "markdown" },
      }),

      null_ls.builtins.formatting.nginx_beautifier.with({
        args = { "-s", "4", "-i", "-o", "$FILENAME" },
        filetypes = {
          "nginx",
          "conf",
        },
      }),
      null_ls.builtins.formatting.shfmt,
      -- python
      -- null_ls.builtins.formatting.black,
      -- null_ls.builtins.formatting.isort,
    }
    if vim.fn.filereadable(git_cmd .. "/.groovylintrc.json") ~= 1 then
      -- null ls sources only if you aren't in a git repo
      table.insert(
        lSsources,
        null_ls.builtins.diagnostics.npm_groovy_lint.with({
          args = { "-o", "json", "--config", os.getenv("HOME") .. "/.config/groovylint/groovylint.json", "-" },
          filetypes = {
            "Jenkinsfile",
            "groovy",
          },
        })
      )
      table.insert(
        lSsources,
        null_ls.builtins.formatting.npm_groovy_lint.with({
          args = {
            "--format",
            "--failon",
            "none",
            "--config",
            os.getenv("HOME") .. "/.config/groovylint/groovylint.json",
            "-",
          },
          filetypes = {
            "Jenkinsfile",
            "groovy",
          },
        })
      )
    else
      -- your in a git directory
      table.insert(
        lSsources,
        null_ls.builtins.diagnostics.npm_groovy_lint.with({
          filetypes = {
            "Jenkinsfile",
            "groovy",
          },
        })
      )
      table.insert(
        lSsources,
        null_ls.builtins.formatting.npm_groovy_lint.with({
          args = {
            "--format",
            "--failon",
            "none",
            "-",
          },
          filetypes = {
            "Jenkinsfile",
            "groovy",
          },
        })
      )
    end
    null_ls.setup({
      sources = lSsources,
    })
    vim.o.updatetime = 250
  end,
}
