return {

  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
    },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    },
    ---@class PluginLspOpts
    config = function()
      -- LSP settings

      local border = {
        { "┌", "FloatBorder" },
        { "─", "FloatBorder" },
        { "┐", "FloatBorder" },
        { "│", "FloatBorder" },
        { "┘", "FloatBorder" },
        { "─", "FloatBorder" },
        { "└", "FloatBorder" },
        { "│", "FloatBorder" },
      }
      -- Add the border on hover and on signature help popup window
      local handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
      }
      -- Add border to the diagnostic popup window
      vim.diagnostic.config({
        virtual_text = {
          prefix = "■ ", -- Could be '●', '▎', 'x', '■', , 
        },
        float = { border = border },
      })
      -- make nvim-cmp aware of extra capabilities coming from lsp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- disable virtal text for corn.nvim
      vim.diagnostic.config({ virtual_text = false })
      vim.g.diagnostics_active = true
      function _G.toggle_diagnostics()
        if vim.g.diagnostics_active then
          vim.g.diagnostics_active = false
          vim.diagnostic.disable()
        else
          vim.g.diagnostics_active = true
          vim.diagnostic.enable()
        end
      end

      vim.api.nvim_set_keymap(
        "n",
        "<leader>lt",
        ":call v:lua.toggle_diagnostics()<CR>",
        { desc = "toggle_diagnostics" }
      )
      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
        -- Mappings.
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "lsp declaration" })
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "lsp definition" })
        vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "lsp code action" })
        -- don't set the keywordprg if we have one we already want
        if vim.opt_local.keywordprg:get() == "" then
          vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "lsp buffer hover" })
        end
        vim.keymap.set("n", "<leader>i", "<cmd>lua vim.lsp.buf.implementation()<cr>", { desc = "lsp implementation" })
        vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "lsp type defintion" })
        vim.keymap.set("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "lsp rename" })
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "lsp references" })
        vim.keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "lsp diagnostics" })
        vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "lsp diagnostic goto next" })
        vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "lsp diagnostic goto prev" })
        vim.keymap.set(
          "n",
          "<leader>q",
          "<cmd>lua vim.diagnostic.set_loclist()<cr>",
          { desc = "lsp diagnostic qixfix" }
        )
        vim.keymap.set("n", "<leader>ld", "<cmd>lua vim.diagnostic.disable()<cr>", { desc = "lsp diagnostic disable" })
        vim.keymap.set("n", "<leader>le", "<cmd>lua vim.diagnostic.enable()<cr>", { desc = "lsp diagnostic enable" })
        vim.keymap.set("n", "<leader>=", function()
          vim.lsp.buf.format({
            async = true,
          })
        end, { desc = "LSP Format" })
        vim.keymap.set("x", "<leader>=", function()
          vim.lsp.buf.format({
            async = true,
            range = {
              vim.inspect(vim.api.nvim_buf_get_mark(0, "<")),
              vim.inspect(vim.api.nvim_buf_get_mark(0, ">")),
            },
          })
        end, { desc = "LSP Format" })
      end

      local lspconfig = require("lspconfig")

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "bashls",
          -- "groovyls",
          -- "jedi_language_server",
          "ansiblels",
          "yamlls",
          "jsonls",
          "tailwindcss",
          "tsserver",
          "ruff_lsp",
          "basedpyright",
        },
        automatic_installation = true,
      })
      require("mason-tool-installer").setup({

        -- a list of all tools you want to ensure are installed upon start
        ensure_installed = {
          "stylua",
          "shellcheck",
          "shfmt",
          "ruff",
          "autopep8",
          "black",
          "isort",
          "pydocstyle",
          "npm-groovy-lint",
          "ansible-lint",
        },
      })

      require("mason-lspconfig").setup_handlers({
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities,
            handlers = handlers,
          })
        end,
        -- Next, you can provide a dedicated handler for specific servers.
        ["ansiblels"] = function()
          lspconfig.ansiblels.setup({
            settings = {
              ansible = {
                ansible = {
                  useFullyQualifiedCollectionNames = true,
                },
                validation = {
                  lint = {
                    enabled = true,
                    arguments = "-x role-name,package-latest,fqcn-builtins",
                  },
                },
              },
            },
            on_attach = on_attach,
            capabilities = capabilities,
          })
        end,
        ["yamlls"] = function()
          lspconfig.yamlls.setup({
            settings = {
              yaml = {
                keyOrdering = false,
              },
            },
            on_attach = on_attach,
            capabilities = capabilities,
          })
        end,
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            settings = {
              Lua = {
                hint = { enable = true },
                workspace = {
                  checkThirdParty = false,
                },
              },
            },
            on_attach = on_attach,
            capabilities = capabilities,
          })
        end,
        ["pylsp"] = function()
          lspconfig.pylsp.setup({
            plugins = {
              pyflakes = { enabled = false },
              pylint = { enabled = false },
            },
            on_attach = on_attach,
            capabilities = capabilities,
          })
        end,
      })
    end,
  },
  "onsails/lspkind-nvim",
  "nvim-lua/lsp-status.nvim",
  {
    "folke/trouble.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    init = function()
      vim.keymap.set("n", "<leader>lx", function()
        local trouble_enabled = vim.inspect(vim.g.trouble_enabled)
        require("trouble").toggle()
        if trouble_enabled == "nil" then
          vim.g.trouble_enabled = "true"
          vim.keymap.set("n", "<A-j>", function()
            require("trouble").next({ skip_groups = true, jump = true })
          end)
          vim.keymap.set("n", "<A-k>", function()
            require("trouble").previous({ skip_groups = true, jump = true })
          end)
        else
          vim.g.trouble_enabled = nil
          vim.keymap.del("n", "<A-j>", {})
          vim.keymap.del("n", "<A-k>", {})
          vim.keymap.set("n", "<A-j>", ":cnext<cr>", { noremap = false, silent = true })
          vim.keymap.set("n", "<A-k>", ":cprev<cr>", { noremap = false, silent = true })
        end
      end, { desc = "open diagnostics" })
    end,
    opts = {
      mode = "workspace_diagnostics",
    },
  },
  {
    "danymat/neogen",
    config = function()
      require("neogen").setup({
        enabled = true,
      })
      vim.keymap.set({ "n" }, "<Leader>lw", function()
        vim.cmd([[:Neogen]])
      end, { silent = true, noremap = true, desc = "Neogen Generate language docstring." })
    end,
  },
  {
    "j-hui/fidget.nvim",
    opts = {},
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    enabled = false,
    config = function()
      vim.keymap.set({ "n" }, "<Leader>k", function()
        require("lsp_signature").toggle_float_win()
      end, { silent = true, noremap = true, desc = "toggle signature" })
      require("lsp_signature").setup({
        -- floating_window = true,
        -- floating_window_above_cur_line = true,
        -- floating_window_off_y = -5,
      })
    end,
  },
  {
    "RaafatTurki/corn.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {
      on_toggle = function(is_hidden)
        vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
      end,
    },
    config = function(_, opts)
      require("corn").setup(opts)
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
}
