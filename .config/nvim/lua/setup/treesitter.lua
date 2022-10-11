
-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "c",
      "lua",
      "javascript",
      "typescript",
      "html",
      "yaml",
      "python",
      "bash",
      "go",
      "dockerfile",
      "vim",
      "ruby",
      "perl",
      "comment",
      "query",
      "make",
      "php",
      "rasi",
      "http",
      "json",
      "css",
      "sql",
      "scss",
      "svelte",
      "regex",
      "markdown",
      "markdown_inline",
    },
  highlight = {
    enable = true,
    -- additional_vim_regex_highlighting = true,
    additional_vim_regex_highlighting = {
      "groovy",
      "Jenkinsfile",
    },
    disable = {
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = false,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
})
vim.g.did_load_filetypes = false
vim.g.do_filetype_lua = 1
