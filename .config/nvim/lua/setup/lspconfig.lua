-- LSP settings

-- make nvim-cmp aware of extra capabilities coming from lsp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  -- Mappings.
  vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
  vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
  vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>")
  vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
  vim.keymap.set("n", "<leader>i", "<cmd>lua vim.lsp.buf.implementation()<cr>")
  vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
  vim.keymap.set("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<cr>")
  vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")
  vim.keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<cr>")
  vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
  vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")
  vim.keymap.set("n", "<leader>q", "<cmd>lua vim.diagnostic.set_loclist()<cr>")
  vim.keymap.set("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<cr>")
  vim.keymap.set("n", "<leader>ld", "<cmd>lua vim.diagnostic.disable()<cr>")
  vim.keymap.set("n", "<leader>le", "<cmd>lua vim.diagnostic.enable()<cr>")
  vim.keymap.set("n", "<leader>=", "<cmd>lua vim.lsp.buf.formatting_seq_sync(nil, 7500)<cr>")
end

require("nvim-lsp-installer").setup({})
require("nvim-lightbulb").setup({ autocmd = { enabled = true } })
local lspconfig = require("lspconfig")

lspconfig.sumneko_lua.setup({
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        -- path = path,
      },
      completion = { callSnippet = "Both" },
      diagnostics = {
        globals = { "vim" },
      },
      telemetry = { enable = false },
    },
  },
  on_attach = on_attach,
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities),
})
lspconfig.bashls.setup({
  on_attach = on_attach,
})
lspconfig.tailwindcss.setup({
  on_attach = on_attach,
})
lspconfig.ansiblels.setup({
  settings = {
    ansible = {
      ansible = {
        path = "ansible",
      },
      ansibleLint = {
        enabled = true,
        path = "ansible-lint",
        arguments = "-x fqcn-builtins,role-name",
      },
      executionEnvironment = {
        enabled = false,
      },
      python = {
        interpreterPath = "python",
      },
    },
  },
  on_attach = on_attach,
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities),
})

lspconfig.pyright.setup({
  on_attach = on_attach,
})

local util = require("lspconfig.util")
lspconfig.groovyls.setup({
  filetypes = { "groovy", "Jenkinsfile" },
  root_dir = function(fname)
    return util.root_pattern("src")(fname) or util.find_git_ancestor(fname)
  end,
  on_attach = on_attach,
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities),
})
lspconfig.tsserver.setup({
  on_attach = on_attach,
})

-- vim.lsp.set_log_level("debug")
