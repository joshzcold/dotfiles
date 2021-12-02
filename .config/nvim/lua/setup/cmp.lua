 -- Setup nvim-cmp.
local cmp = require'cmp'
local lspkind = require('lspkind')

cmp.setup({
  formatting = {
      format = lspkind.cmp_format({with_text = false, maxwidth = 50})
  },
  snippet = {
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- If you want to remove the default `<C-y>` mapping, You can specify `cmp.config.disable` value.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({}),
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' })
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'ultisnips' }, -- For ultisnips users.
    {
        name = 'buffer', 
        options = {
            get_bufnrs = function()
                return vim.api.nvim_list_bufs()
            end
        }
    },
    { name = 'path' },
    -- -- Use buffer source for `/`.
    -- cmp.setup.cmdline('/', {
    --   sources = {
    --     { name = 'buffer' }
    --   }
    -- })

    -- Use cmdline & path source for ':'.
    -- cmp.setup.cmdline(':', {
    --   sources = cmp.config.sources( {
    --     { name = 'cmdline' }
    --   })
    -- })
  })
})

vim.cmd[[
autocmd FileType Jenkinsfile lua require'cmp'.setup.buffer {
  \   sources = {
  \     { name = 'jenkinsfile',
  \        options = {
  \            jenkins_url = "http://jenkins.secmet.co:8080"
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
  \     { name = 'ultisnips' }
  \   },
  \ }
]]
