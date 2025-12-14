local function set_groovy_classpath()
  local Job = require("plenary.job")
  local gradle_dir = vim.fs.dirname(SearchUp("build.gradle"))
  if not gradle_dir then
    return
  end
  vim.notify("groovyls: starting gradle dependencies install at: " .. gradle_dir, vim.log.levels.INFO)
  Job
      :new({
        command = "./gradlew",
        args = {
          "dependencies",
        },
        cwd = gradle_dir,
        on_exit = function(j, _)
          vim.schedule(function()
            if j.code ~= 0 then
              vim.notify("./gradlew dependencies: " .. vim.inspect(j._stderr_results), vim.log.levels.ERROR)
            else
              Job
                  :new({
                    command = "gradle-classpath",
                    cwd = gradle_dir,
                    on_exit = function(k, _)
                      vim.schedule(function()
                        if k.code ~= 0 then
                          vim.notify("gradle-classpath: " .. vim.inspect(k._stderr_results), vim.log.levels.ERROR)
                        else
                          local _classpath_results_stdout = k._stdout_results[1]
                          local classpath_results = vim.split(_classpath_results_stdout, ":")
                          vim.notify("Setting classpath in groovyls ...", vim.log.levels.INFO)
                          local groovy_lsp_client = vim.lsp.get_clients({ name = "groovyls" })[1]
                          if not groovy_lsp_client then
                            vim.notify("Error lsp client groovyls not found.", vim.log.levels.ERROR)
                            return
                          end
                          if groovy_lsp_client.settings then
                            groovy_lsp_client.settings = vim.tbl_deep_extend(
                              "force",
                              groovy_lsp_client.settings,
                              { groovy = { classpath = classpath_results } }
                            )
                          else
                            groovy_lsp_client.config.settings = vim.tbl_deep_extend(
                              "force",
                              groovy_lsp_client.config.settings,
                              { groovy = { classpath = classpath_results } }
                            )
                          end
                          groovy_lsp_client.notify(
                            "workspace/didChangeConfiguration",
                            { settings = groovy_lsp_client.settings }
                          )
                        end
                      end)
                    end,
                  })
                  :start()
            end
          end)
        end,
      })
      :start()
end

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
      --
      -- Add border to the diagnostic popup window
      vim.diagnostic.config({
        underline = false,
        virtual_text = {
          prefix = " ", -- Could be '●', '▎', 'x', '■', , 
        },
        float = {
          border = "single",
        },
      })
      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      local cmp_is_loaded = package.loaded["cmp_nvim_lsp"] ~= nil
      if cmp_is_loaded then
        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
        -- print("loaded lsp capabilities with cmp")
      end

      local blink_is_loaded = package.loaded["blink.cmp"] ~= nil
      if blink_is_loaded then
        capabilities =
            vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities(capabilities))
        -- print("loaded lsp capabilities with blink")
      end

      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          -- Mappings.
          vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "lsp diagnostics" })
          vim.keymap.set("n", "<leader>i", vim.lsp.buf.implementation, { desc = "lsp implementation" })
          vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "lsp rename" })
          vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, { desc = "lsp buffer hover" })
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "lsp diagnostic goto next" })
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "lsp diagnostic goto prev" })
          -- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "lsp declaration" })
          vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { desc = "lsp code action" })
          -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "lsp definition" })
          -- vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "lsp references" })
          vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "lsp type defintion" })
          vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "lsp diagnostic qixfix" })

          -- vim.keymap.set("n", "<leader>=", function()
          --   vim.lsp.buf.format({ async = true })
          -- end, { desc = "lsp format" })

          vim.keymap.set("x", "<leader>=", function()
            vim.lsp.buf.format({
              async = true,
              range = {
                vim.inspect(vim.api.nvim_buf_get_mark(0, "<")),
                vim.inspect(vim.api.nvim_buf_get_mark(0, ">")),
              },
            })
          end, { desc = "lsp format range" })

          vim.lsp.handlers["textDocument/references"] = function(_, result)
            vim.g.lsp_last_word = vim.fn.expand("<cword>")
            if not result then
              return
            end
            if #result == 0 then
              vim.notify("Getting references...")
              return
            end
            if #result == 1 then
              vim.notify("No references found...", vim.log.levels.WARN)
              return
            end
            vim.notify("LSP references are in quickfix", vim.log.levels.INFO)
            vim.fn.setqflist(vim.lsp.util.locations_to_items(result, "utf-8"))
            print(vim.inspect(result))
            vim.cmd([[cnext]])
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.keymap.set("n", "<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, { desc = "lsp toggle inlay hints" })
          end

          if client and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
          end
        end,
      })

      local servers = {
        bashls = {},
        gopls = {},
        ts_ls = {},
        tailwindcss = {
          filetypes = { "templ", "astro", "javascript", "typescript", "react", "typescriptreact", },
          settings = {
            tailwindCSS = {
              includeLanguages = {
                templ = "html",
              },
            },
          },
        },
        jsonls = {},
        jdtls = {},
        terraformls = {},
        ansiblels = {
          settings = {
            ansible = {
              ansible = {
                useFullyQualifiedCollectionNames = true,
              },
              validation = {
                lint = {
                  enabled = false,
                },
              },
            },
          },
        },
        helm_ls = {
          on_attach = function(_, _)
            vim.api.nvim_set_keymap("n", "<leader>yc", "", {
              desc = "Yamlls: insert a crd for kubernetes.",
              callback = function()
                require('user.yaml-additional-schemas').init()
              end
            })
          end,
        },
        yamlls = {
          yaml = {
            keyOrdering = false,
          },
          on_attach = function(_, _)
            vim.api.nvim_set_keymap("n", "<leader>yc", "", {
              desc = "Yamlls: insert a crd for kubernetes.",
              callback = function()
                require('user.yaml-additional-schemas').init()
              end
            })
          end,
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = {
                  "vim",
                  "Snacks"
                }
              },
              format = {
                enable = true,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                },
              },
              hint = { enable = true },
              workspace = {
                checkThirdParty = false,
                ignoreDir = { "undodir/**" }
              },
            },
          },
        },
        -- pylsp = {
        --   plugins = {
        --     pyflakes = { enabled = false },
        --     pylint = { enabled = false },
        --   },
        -- },
        groovyls = {
          filetypes = {
            "groovy",
            -- "Jenkinsfile",
          },
          settings = {
            groovy = {
              classpath = {},
            },
          },
          on_attach = function(_, _)
            set_groovy_classpath()
          end,
        },
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "standard",
              },
            },
            python = {
              analysis = {
                diagnosticSeverityOverrides = {
                  ignore = { "*" },
                },
              },
            },
          },
        },
      }

      require("mason").setup()
      local ensure_installed = vim.tbl_keys(servers or {})


      local tools_ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "ruff",
        "pydocstyle",
        "npm-groovy-lint",
        "ansible-lint",
      }

      require("mason-tool-installer").setup({ ensure_installed = tools_ensure_installed })

      require("mason-lspconfig").setup({
        automatic_enable = true,
        ensure_installed = ensure_installed,
      })


      for server in pairs(servers) do
        local server_config = servers[server]
        vim.lsp.config(server, server_config)
      end
    end,
  },
  {
    "Davidyz/inlayhint-filler.nvim",
    keys = {
      {
        "<leader>li", -- Use whatever keymap you want.
        function()
          require("inlayhint-filler").fill()
        end,
        desc = "Insert the inlay-hint under cursor into the buffer.",
        mode = { "n", "v" }, -- include 'v' if you want to use it in visual selection mode
      },
    },
  },
  "onsails/lspkind-nvim",
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
    "rachartier/tiny-inline-diagnostic.nvim",
    enabled = false,
    event = "VeryLazy", -- Or `LspAttach`
    config = function()
      require("tiny-inline-diagnostic").setup()
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
