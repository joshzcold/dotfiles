return {
  ---@module 'lazy'
  ---@type LazySpec
  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "folke/ts-comments.nvim", opts = {} },
    },

    branch = "main",
    build = function()
      -- update parsers, if TSUpdate exists
      if vim.fn.exists(":TSUpdate") == 2 then
        vim.cmd("TSUpdate")
      end
    end,

    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    ---@module 'nvim-treesitter'
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields

    config = function(_, _)
      local ensure_installed = {
        "c",
        "comment",
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
        -- "comment",
        "query",
        "make",
        "php",
        "tsx",
        "rasi",
        -- "http",
        "json",
        "jinja",
        "css",
        -- "sql",
        -- "scss",
        "svelte",
        "regex",
        "markdown",
        -- "markdown_inline",
      }

      -- make sure nvim-treesitter can load
      local ok, nvim_treesitter = pcall(require, "nvim-treesitter")

      -- no nvim-treesitter, maybe fresh install
      if not ok then
        return
      end

      nvim_treesitter.install(ensure_installed)
      -- on main branch, treesitter isn't started automatically

      local ts_filetypes = vim
        .iter(ensure_installed)
        :map(function(lang)
          return vim.treesitter.language.get_filetypes(lang)
        end)
        :flatten()
        :totable()
      vim.api.nvim_create_autocmd({ "Filetype" }, {
        desc = "Setup treesitter for a buffer",
        pattern = ts_filetypes,
        group = vim.api.nvim_create_augroup("ts_setup", { clear = true }),
        callback = function(e)
          vim.treesitter.start(e.buf)
          vim.wo.foldmethod = "expr"
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  ---@module 'lazy'
  ---@type LazySpec
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",

    branch = "main",

    keys = {
      {
        "[f",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
        end,
        desc = "prev function",
        mode = { "n", "x", "o" },
      },
      {
        "]f",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
        end,
        desc = "next function",
        mode = { "n", "x", "o" },
      },
      {
        "[F",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
        end,
        desc = "prev function end",
        mode = { "n", "x", "o" },
      },
      {
        "]F",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
        end,
        desc = "next function end",
        mode = { "n", "x", "o" },
      },
      {
        "[a",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.outer", "textobjects")
        end,
        desc = "prev argument",
        mode = { "n", "x", "o" },
      },
      {
        "]a",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.outer", "textobjects")
        end,
        desc = "next argument",
        mode = { "n", "x", "o" },
      },
      {
        "[A",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@parameter.outer", "textobjects")
        end,
        desc = "prev argument end",
        mode = { "n", "x", "o" },
      },
      {
        "]A",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@parameter.outer", "textobjects")
        end,
        desc = "next argument end",
        mode = { "n", "x", "o" },
      },
      {
        "[s",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@block.outer", "textobjects")
        end,
        desc = "prev block",
        mode = { "n", "x", "o" },
      },
      {
        "]s",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@block.outer", "textobjects")
        end,
        desc = "next block",
        mode = { "n", "x", "o" },
      },
      {
        "[S",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@block.outer", "textobjects")
        end,
        desc = "prev block",
        mode = { "n", "x", "o" },
      },
      {
        "]S",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@block.outer", "textobjects")
        end,
        desc = "next block",
        mode = { "n", "x", "o" },
      },
      {
        "gan",
        function()
          require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
        end,
        desc = "swap next argument",
      },
      {
        "gap",
        function()
          require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
        end,
        desc = "swap prev argument",
      },
    },

    opts = {
      move = {
        enable = true,
        set_jumps = true,
      },
      swap = {
        enable = true,
      },
    },
  },
  {
    "Wansmer/treesj",
    keys = {
      {
        "<space>jm",
        function()
          require("treesj").toggle()
        end,
        "Treesitter toggle join",
      },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      use_default_keymaps = false,
      max_join_length = 1000,
    },
  },
  {
    "sheerun/vim-polyglot",
  },
}
