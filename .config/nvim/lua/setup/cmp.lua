-- Setup nvim-cmp.
local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

cmp.setup({
  formatting = {
    format = lspkind.cmp_format({ with_text = false, maxwidth = 50 }),
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable, -- If you want to remove the default `<C-y>` mapping, You can specify `cmp.config.disable` value.
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<CR>"] = cmp.mapping.confirm({}),
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
    ["<C-j>"] = function(fallback)
      if luasnip.expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
      else
        fallback()
      end
    end,
    ["<C-k>"] = function(fallback)
      if luasnip.jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
      else
        fallback()
      end
    end,
  },
  sources = cmp.config.sources({
    { name = "luasnip" },
    { name = "nvim_lsp" },
    {
      name = "buffer",
      options = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end,
      },
    },
    -- {
    --   name = "rg",
    --   option = {
    --     debounce = 500,
    --     additional_arguments = "--smart-case --max-depth 4",
    --     git_check = true,
    --   },
    -- },
    { name = "nvim_lua" },
    { name = "path" },
  }),
})

vim.cmd([[
autocmd FileType Jenkinsfile lua require'cmp'.setup.buffer {
  \   sources = {
  \     { name = 'jenkinsfile',
  \        option = {
  \            jenkins_url = "https://jenkins.secmet.co"
  \        }
  \     },
  \     { 
  \         name = 'buffer',
  \         options = {
  \             get_bufnrs = function()
  \                 return vim.api.nvim_list_bufs()
  \             end
  \         }
  \     },
  \     { name = 'luasnip' },
  \     {
  \       name = "rg",
  \       option = {
  \         debounce = 500,
  \         additional_arguments = "--smart-case --max-depth 4",
  \       },
  \     },
  \   },
  \ }
]])
-- If you want insert `(` after select function or method item
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
