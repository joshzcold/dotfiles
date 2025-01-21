return {
  {
    "saghen/blink.cmp",
    enabled = true,
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = {
      "mikavilpas/blink-ripgrep.nvim",
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
    },

    -- use a release tag to download pre-built binaries
    version = "*",
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',

    opts = {
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 0,
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
      },
      keymap = {
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "accept", "fallback" },

        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },

        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-j>"] = { "snippet_forward" },
        ["<C-k>"] = { "snippet_backward" },
      },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      -- default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, via `opts_extend`

      -- experimental auto-brackets support
      -- completion = { accept = { auto_brackets = { enabled = true } } }

      -- experimental signature help support
      -- signature = { enabled = true }
      snippets = {
        preset = "luasnip",
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },
      -- allows extending the providers array elsewhere in your config
      -- without having to redefine it
      sources = {
        default = function(_)
          local success, node = pcall(vim.treesitter.get_node)
          -- If in comment then only do buffer and ripgrep
          if
              success
              and node
              and vim.tbl_contains({ "comment", "line_comment", "block_comment", "comment_content" }, node:type())
          then
            return { "buffer", "ripgrep" }
          else
            return { "lsp", "path", "snippets", "buffer", "ripgrep" }
          end
        end,
        providers = {
          buffer = {
            name = "Buffer",
            module = "blink.cmp.sources.buffer",
            opts = {
              get_bufnrs = function()
                return vim.tbl_filter(function(bufnr)
                  return vim.bo[bufnr].buftype == ""
                end, vim.api.nvim_list_bufs())
              end,
            },
            transform_items = function(_, items)
              for _, item in ipairs(items) do
                item.labelDetails = {
                  description = "(buf)",
                }
              end
              return items
            end,
          },
          ripgrep = {
            enabled = function()
              -- disable for the sm repo. Its just too big for ripgrep
              local git_cmd = vim.fn.system("git rev-parse --show-toplevel | tr -d '\n'")
              return not string.find(git_cmd, "dev/sm")
            end,
            module = "blink-ripgrep",
            name = "Ripgrep",
            opts = {
              project_root_marker = { "Dockerfile", "Jenkinsfile", ".git" },
              project_root_fallback = false,
              future_features = {
                -- Kill previous searches when a new search is started. This is
                -- useful to save resources and might become the default in the
                -- future.
                kill_previous_searches = true,
              },
            },
            transform_items = function(_, items)
              for _, item in ipairs(items) do
                item.labelDetails = {
                  description = "(rg)",
                }
              end
              return items
            end,
            score_offset = -10,
          },
          snippets = {
            name = "Snippets",
            module = "blink.cmp.sources.snippets",
            score_offset = 10,
          },
          lsp = {
            name = "LSP",
            module = "blink.cmp.sources.lsp",
            score_offset = 50,
          },
        },
      },
    },
    opts_extend = { "sources.default" },
  },
}
