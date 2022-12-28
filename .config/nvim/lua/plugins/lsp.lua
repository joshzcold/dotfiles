return {

  {
    "neovim/nvim-lspconfig",
    config = function()
      -- LSP settings

      -- make nvim-cmp aware of extra capabilities coming from lsp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
        -- Mappings.
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "lsp declaration" })
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "lsp definition" })
        vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "lsp code action" })
        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "lsp buffer hover" })
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
        vim.keymap.set(
          "n",
          "<leader>=",
          "<cmd>lua vim.lsp.buf.format({ timeout_ms = 2000 })<cr>",
          { desc = "LSP Format" }
        )
      end

      require("nvim-lightbulb").setup({ autocmd = { enabled = true } })
      local lspconfig = require("lspconfig")

      require("mason").setup()
      require("mason-lspconfig").setup({

        ensure_installed = {
          "sumneko_lua",
          "bashls",
          "groovyls",
          "pyright",
          "ansiblels",
          "yamlls",
          "jsonls",
          "tailwindcss",
          "nginx-language-server",
          "tsserver",
        },
        automatic_installation = true,
      })

      require("mason-lspconfig").setup_handlers({
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup({
            on_attach = on_attach,
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),
          })
        end,
        -- Next, you can provide a dedicated handler for specific servers.
        -- For example, a handler override for the `rust_analyzer`:
        ["sumneko_lua"] = function()
          lspconfig.sumneko_lua.setup({
            settings = {
              Lua = {
                runtime = {
                  version = "LuaJIT",
                },
                completion = { callSnippet = "Both" },
                diagnostics = {
                  globals = { "vim" },
                },
                telemetry = { enable = false },
              },
            },
            on_attach = on_attach,
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),
          })
        end,
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    dependencies = {
      { "williamboman/mason-lspconfig.nvim" },
    },
  },
  {
    "kosayoda/nvim-lightbulb",
    config = function()
      require("nvim-lightbulb").setup({ autocmd = { enabled = true } })
    end,
  },
  "onsails/lspkind-nvim",
  "nvim-lua/lsp-status.nvim",
  { "folke/trouble.nvim" },
  {
    "danymat/neogen",
    config = function()
      require("neogen").setup({
        enabled = true,
      })
    end,
  },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({ window = { winblend = 0 } })
    end,
  },
}
