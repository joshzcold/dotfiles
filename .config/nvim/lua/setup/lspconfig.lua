-- LSP settings
local nvim_lsp = require("lspconfig")
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  print("LSP Attached...")
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  -- Mappings.
  vim.keymap.set("n", "gD", function()
    vim.lsp.buf.declaration()
  end)
  vim.keymap.set("n", "gd", function()
    vim.lsp.buf.definition()
  end)
  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover()
  end)
  vim.keymap.set("n", "gi", function()
    vim.lsp.buf.implementation()
  end)
  vim.keymap.set("n", "<leader>lsh", function()
    vim.lsp.buf.signature_help()
  end)
  vim.keymap.set("n", "<leader>lD", function()
    vim.lsp.buf.type_definition()
  end)
  vim.keymap.set("n", "<leader>lr", function()
    vim.lsp.buf.rename()
  end)
  vim.keymap.set("n", "gr", function()
    vim.lsp.buf.references()
  end)
  vim.keymap.set("n", "<leader>e", function()
    vim.lsp.diagnostic.show_line_diagnostics()
  end)
  vim.keymap.set("n", "[d", function()
    vim.lsp.diagnostic.goto_prev()
  end)
  vim.keymap.set("n", "]d", function()
    vim.lsp.diagnostic.goto_next()
  end)
  vim.keymap.set("n", "<leader>lq", function()
    vim.lsp.diagnostic.set_loclist()
  end)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    vim.keymap.set("n", "<leader>lf", function()
      vim.lsp.buf.formatting()
    end)
  elseif client.resolved_capabilities.document_range_formatting then
    vim.keymap.set("n", "<space>lf", function()
      vim.lsp.buf.range_formatting()
    end)
  end
end

local lsp_installer = require("nvim-lsp-installer")

-- auto install list of servers
local servers = {
  "bashls",
  "pyright",
  "groovyls",
  "tailwindcss",
  -- "ansiblels",
  "sumneko_lua",
  "tsserver",
}

for _, name in pairs(servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found and not server:is_installed() then
    print("Installing " .. name)
    server:install()
  end
end
--

local server_opts = {
  -- Provide settings that should only apply to the "eslintls" server
  ["groovyls"] = function(opts)
    opts.filetypes = { "groovy", "Jenkinsfile" }
  end,
  ["sumneko_lua"] = function(opts)
    local library = {}

    local path = {} -- vim.split(package.path, ";")

    -- this is the ONLY correct way to setup your path
    table.insert(path, "lua/?.lua")
    table.insert(path, "lua/?/init.lua")

    local function add(lib)
      for _, p in pairs(vim.fn.expand(lib, false, true)) do
        q = vim.loop.fs_realpath(p)
        library[q] = true
      end
    end

    -- add runtime
    add("$VIMRUNTIME")

    -- add plugins
    -- if you're not using packer, then you might need to change the paths below
    add("/home/joshua/.local/share/nvim/site/pack/packer/opt/")
    add("/home/joshua/.local/share/nvim/site/pack/packer/start/")
    opts.settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = path,
        },
        completion = { callSnippet = "Both" },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = library,
          maxPreload = 2000,
          preloadFileSize = 50000,
        },
        telemetry = { enable = false },
      },
    }
  end,
  ["ansiblels"] = function(opts)
    opts.settings = {
      ansible = {
        ansible = {
          path = "ansible",
        },
        ansibleLint = {
          enabled = false,
          path = "ansible-lint",
        },
        executionEnvironment = {
          enabled = false,
        },
        python = {
          interpreterPath = "python",
        },
      },
    }
  end,
}

-- make nvim-cmp aware of extra capabilities coming from lsp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  if server_opts[server.name] then
    -- Enhance the default opts with the server-specific ones
    server_opts[server.name](opts)
  end

  server:setup_lsp(opts)
end)
