return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "nvim-treesitter/playground" },
      { "sheerun/vim-polyglot" },
    },
    config = function()
      -- Treesitter configuration
      -- Parsers must be installed manually via :TSInstall
      require("nvim-treesitter.configs").setup({
        modules = {
          "highlight",
          "indent",
        },
        sync_install = false,
        auto_install = true,
        ignore_install = {},
        ensure_installed = {
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
        },
        highlight = {
          enable = true,
          -- additional_vim_regex_highlighting = true,
          additional_vim_regex_highlighting = {
            "groovy",
            "Jenkinsfile",
          },
          disable = {},
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
          enable = true,
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

      -- Run treesitter_migrate() in your init.lua or in a Colorscheme autocmd.
      -- See https://www.reddit.com/r/neovim/comments/y5rofg/recent_treesitter_update_borked_highlighting/
      -- https://github.com/nvim-treesitter/nvim-treesitter/issues/2293#issuecomment-1279974776

      -- the @punctuation.delimiter links to Delimiter (which is new)
      -- Also other new upstream highlight values, so the better solution is to go through the following
      -- and properly update/add the highlight for these
      -- so like leave @punctuation.delimiter linking to Delimiter and style the new Delimiter

      local treesitter_migrate = function()
        local map = {
          ["annotation"] = "TSAnnotation",

          ["attribute"] = "TSAttribute",

          ["boolean"] = "TSBoolean",

          ["character"] = "TSCharacter",
          ["character.special"] = "TSCharacterSpecial",

          ["comment"] = "TSComment",

          ["conditional"] = "TSConditional",

          ["constant"] = "TSConstant",
          ["constant.builtin"] = "TSConstBuiltin",
          ["constant.macro"] = "TSConstMacro",

          ["constructor"] = "TSConstructor",

          ["debug"] = "TSDebug",
          ["define"] = "TSDefine",

          ["error"] = "TSError",
          ["exception"] = "TSException",

          ["field"] = "TSField",

          ["float"] = "TSFloat",

          ["function"] = "TSFunction",
          ["function.call"] = "TSFunctionCall",
          ["function.builtin"] = "TSFuncBuiltin",
          ["function.macro"] = "TSFuncMacro",

          ["include"] = "TSInclude",

          ["keyword"] = "TSKeyword",
          ["keyword.function"] = "TSKeywordFunction",
          ["keyword.operator"] = "TSKeywordOperator",
          ["keyword.return"] = "TSKeywordReturn",

          ["label"] = "TSLabel",

          ["method"] = "TSMethod",
          ["method.call"] = "TSMethodCall",

          ["namespace"] = "TSNamespace",

          ["none"] = "TSNone",
          ["number"] = "TSNumber",

          ["operator"] = "TSOperator",

          ["parameter"] = "TSParameter",
          ["parameter.reference"] = "TSParameterReference",

          ["preproc"] = "TSPreProc",

          ["property"] = "TSProperty",

          ["punctuation.delimiter"] = "TSPunctDelimiter",
          ["punctuation.bracket"] = "TSPunctBracket",
          ["punctuation.special"] = "TSPunctSpecial",

          ["repeat"] = "TSRepeat",

          ["storageclass"] = "TSStorageClass",

          ["string"] = "TSString",
          ["string.regex"] = "TSStringRegex",
          ["string.escape"] = "TSStringEscape",
          ["string.special"] = "TSStringSpecial",

          ["symbol"] = "TSSymbol",

          ["tag"] = "TSTag",
          ["tag.attribute"] = "TSTagAttribute",
          ["tag.delimiter"] = "TSTagDelimiter",

          ["text"] = "TSText",
          ["text.strong"] = "TSStrong",
          ["text.emphasis"] = "TSEmphasis",
          ["text.underline"] = "TSUnderline",
          ["text.strike"] = "TSStrike",
          ["text.title"] = "TSTitle",
          ["text.literal"] = "TSLiteral",
          ["text.uri"] = "TSURI",
          ["text.math"] = "TSMath",
          ["text.reference"] = "TSTextReference",
          ["text.environment"] = "TSEnvironment",
          ["text.environment.name"] = "TSEnvironmentName",

          ["text.note"] = "TSNote",
          ["text.warning"] = "TSWarning",
          ["text.danger"] = "TSDanger",

          ["todo"] = "TSTodo",

          ["type"] = "TSType",
          ["type.builtin"] = "TSTypeBuiltin",
          ["type.qualifier"] = "TSTypeQualifier",
          ["type.definition"] = "TSTypeDefinition",

          ["variable"] = "TSVariable",
          ["variable.builtin"] = "TSVariableBuiltin",
        }

        for capture, hlgroup in pairs(map) do
          vim.api.nvim_set_hl(0, "@" .. capture, { link = hlgroup, default = true })
        end

        local defaults = {
          TSNone = { default = true },
          TSPunctDelimiter = { link = "Delimiter", default = true },
          TSPunctBracket = { link = "Delimiter", default = true },
          TSPunctSpecial = { link = "Delimiter", default = true },

          TSConstant = { link = "Constant", default = true },
          TSConstBuiltin = { link = "Special", default = true },
          TSConstMacro = { link = "Define", default = true },
          TSString = { link = "String", default = true },
          TSStringRegex = { link = "String", default = true },
          TSStringEscape = { link = "SpecialChar", default = true },
          TSStringSpecial = { link = "SpecialChar", default = true },
          TSCharacter = { link = "Character", default = true },
          TSCharacterSpecial = { link = "SpecialChar", default = true },
          TSNumber = { link = "Number", default = true },
          TSBoolean = { link = "Boolean", default = true },
          TSFloat = { link = "Float", default = true },

          TSFunction = { link = "Function", default = true },
          TSFunctionCall = { link = "TSFunction", default = true },
          TSFuncBuiltin = { link = "Special", default = true },
          TSFuncMacro = { link = "Macro", default = true },
          TSParameter = { link = "Identifier", default = true },
          TSParameterReference = { link = "TSParameter", default = true },
          TSMethod = { link = "Function", default = true },
          TSMethodCall = { link = "TSMethod", default = true },
          TSField = { link = "Identifier", default = true },
          TSProperty = { link = "Identifier", default = true },
          TSConstructor = { link = "Special", default = true },
          TSAnnotation = { link = "PreProc", default = true },
          TSAttribute = { link = "PreProc", default = true },
          TSNamespace = { link = "Include", default = true },
          TSSymbol = { link = "Identifier", default = true },

          TSConditional = { link = "Conditional", default = true },
          TSRepeat = { link = "Repeat", default = true },
          TSLabel = { link = "Label", default = true },
          TSOperator = { link = "Operator", default = true },
          TSKeyword = { link = "Keyword", default = true },
          TSKeywordFunction = { link = "Keyword", default = true },
          TSKeywordOperator = { link = "TSOperator", default = true },
          TSKeywordReturn = { link = "TSKeyword", default = true },
          TSException = { link = "Exception", default = true },
          TSDebug = { link = "Debug", default = true },
          TSDefine = { link = "Define", default = true },
          TSPreProc = { link = "PreProc", default = true },
          TSStorageClass = { link = "StorageClass", default = true },

          TSTodo = { link = "Todo", default = true },

          TSType = { link = "Type", default = true },
          TSTypeBuiltin = { link = "Type", default = true },
          TSTypeQualifier = { link = "Type", default = true },
          TSTypeDefinition = { link = "Typedef", default = true },

          TSInclude = { link = "Include", default = true },

          TSVariableBuiltin = { link = "Special", default = true },

          TSText = { link = "TSNone", default = true },
          TSStrong = { bold = true, default = true },
          TSEmphasis = { italic = true, default = true },
          TSUnderline = { underline = true },
          TSStrike = { strikethrough = true },

          TSMath = { link = "Special", default = true },
          TSTextReference = { link = "Constant", default = true },
          TSEnvironment = { link = "Macro", default = true },
          TSEnvironmentName = { link = "Type", default = true },
          TSTitle = { link = "Title", default = true },
          TSLiteral = { link = "String", default = true },
          TSURI = { link = "Underlined", default = true },

          TSComment = { link = "Comment", default = true },
          TSNote = { link = "SpecialComment", default = true },
          TSWarning = { link = "Todo", default = true },
          TSDanger = { link = "WarningMsg", default = true },

          TSTag = { link = "Label", default = true },
          TSTagDelimiter = { link = "Delimiter", default = true },
          TSTagAttribute = { link = "TSProperty", default = true },
        }

        for group, val in pairs(defaults) do
          vim.api.nvim_set_hl(0, group, val)
        end
      end

      treesitter_migrate()
    end,
  },
  {
    "Wansmer/treesj",
    keys = { "<space>mj" },
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
    config = function()
      require("treesj").setup({
        use_default_keymaps = true,
        max_join_length = 1000,
      })
      vim.keymap.set("n", "<leader>mj", function()
        require("treesj").toggle()
      end, { desc = "Treesitter toggle join" })
    end,
  },
}
