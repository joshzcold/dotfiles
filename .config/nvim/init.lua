-- Install packer
local install_path =
vim.fn.stdpath "data" ..
"/site/pack/packer/start/packer.nvim"

if
    vim.fn.empty(
        vim.fn.glob(
            install_path
            )
        ) >
    0
    then
    vim.fn.execute(
        "!git clone https://github.com/wbthomason/packer.nvim " ..
        install_path
        )
end

vim.api.nvim_exec(
    [[
augroup Packer
autocmd!
autocmd BufWritePost init.lua PackerCompile
augroup end
  ]],
    false
    )

vim.cmd(
    [[
if has("autocmd")
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif
]]
    )

vim.cmd(
    [[
" Output the current syntax group
nnoremap <f10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'  . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"  . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>
  ]]
    )

vim.cmd(
    [[
" force syntax reload
autocmd BufEnter,InsertLeave * :syntax sync fromstart
]]
    )

local use =
require(
    "packer"
    ).use
require(
    "packer"
    ).startup(
    function()
        use "wbthomason/packer.nvim" -- Package manager
        use "tpope/vim-fugitive" -- Git commands in nvim
        use "tpope/vim-rhubarb" -- Fugitive-companion to interact with github
        use "tpope/vim-commentary" -- "gc" to comment visual regions/lines
        use "ludovicchabant/vim-gutentags" -- Automatic tags management
        -- UI to select things (files, grep results, open buffers...)
        use {
            "nvim-telescope/telescope.nvim",
            requires = {
                {
                    "nvim-lua/popup.nvim"
                },
                {
                    "nvim-lua/plenary.nvim"
                }
            }
        }
        use "itchyny/lightline.vim" -- Fancier statusline
        -- Add indentation guides even on blank lines
        -- use 'lukas-reineke/indent-blankline.nvim'
        -- Add git related info in the signs columns and popups
        use {
            "lewis6991/gitsigns.nvim",
            requires = {
                "nvim-lua/plenary.nvim"
            }
        }
        -- Highlight, edit, and navigate code using a fast incremental parsing library
        use "nvim-treesitter/nvim-treesitter"
        -- Additional textobjects for treesitter
        use "nvim-treesitter/nvim-treesitter-textobjects"
        use "neovim/nvim-lspconfig" -- Collection of configurations for built-in LSP client
        use "hrsh7th/nvim-compe" -- Autocompletion plugin
        use "L3MON4D3/LuaSnip" -- Snippets plugin
        use "windwp/nvim-autopairs" -- Autopair characters
        use "folke/which-key.nvim" -- emacs style leader preview
        use "simnalamburt/vim-mundo"

        use "SirVer/ultisnips" -- custom code snippets manager
        use "tpope/vim-surround" -- Vim actions to surround word with quotes
        use "sheerun/vim-polyglot"
        use "iamcco/markdown-preview.nvim"
        use "neo4j-contrib/cypher-vim-syntax"

        use "https://github.com/Pocco81/TrueZen.nvim"
        use "https://github.com/vhyrro/neorg"
        use "https://github.com/akinsho/nvim-toggleterm.lua"
        use "wfxr/minimap.vim"

        use "kyazdani42/nvim-web-devicons"
        use "https://github.com/kyazdani42/nvim-tree.lua"
        use "https://github.com/windwp/nvim-ts-autotag"
        use 'https://github.com/norcalli/nvim-colorizer.lua'                       
        use 'tomasiser/vim-code-dark'
    end
    )

vim.cmd [[set termguicolors]]
vim.cmd [[colorscheme codedark]]
vim.cmd ([[
    highlight Comment cterm=italic gui=italic
]])

require( "nvim-autopairs").setup( {
        disable_filetype = {
            "TelescopePrompt",
            "vim"
        }
    })

require 'colorizer'.setup()

require( "nvim-ts-autotag").setup()

--Incremental live completion
vim.o.inccommand = "split"


--Set highlight on search
vim.o.hlsearch = false

--Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

--Do not save when switching buffers
vim.o.hidden = true

--Enable mouse mode
vim.o.mouse = "a"

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.cmd [[set undofile]]
vim.cmd [[set tabstop=2 shiftwidth=2 expandtab]]

--No Swap File
vim.cmd [[set noswapfile]]
vim.cmd [[set nobackup]]
vim.cmd [[set nowritebackup]]

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

vim.o.autoread = true
vim.cmd [[set diffopt+=vertical]]
vim.cmd [[set nohlsearch]]
vim.o.undodir = "/home/joshua/.config/nvim/undodir"
vim.o.scrolloff = 5

--Use system clipboard
vim.cmd [[set clipboard+=unnamedplus]]
vim.cmd [[set splitbelow]]

--Set statusbar
vim.g.lightline = {
    colorscheme = "codedark",
    active = {
        left = {
            {
                "mode",
                "paste"
            },
            {
                "gitbranch",
                "readonly",
                "filename",
                "modified"
            }
        }
    },
    component_function = {
        gitbranch = "fugitive#head"
    }
}

--Remap space as leader key
vim.api.nvim_set_keymap( "", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Remap for dealing with word wrap
vim.api.nvim_set_keymap( "n", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap( "n", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

--Switch windows easier
vim.api.nvim_set_keymap( "n", "<c-j>", "<c-w>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap( "n", "<c-h>", "<c-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap( "n", "<c-k>", "<c-w>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap( "n", "<c-l>", "<c-w>l", { noremap = true, silent = true })

vim.cmd [[vnoremap p "_dP]]

vim.cmd([[
" easier return to other windows, preserves Esc in terminal for vi-mode
tnoremap <c-j> <C-\><C-n><c-w>j
tnoremap <c-k> <C-\><C-n><c-w>k
tnoremap <c-h> <C-\><C-n><c-w>h
tnoremap <c-l> <C-\><C-n><c-w>l
" escape
tnoremap <c-n> <C-\><C-n> ]])

--Use q to quit from fugituve
vim.cmd [[au FileType fugitive nnoremap <silent> <buffer> q :norm gq<cr>]]

--Switch quickfix with alt
vim.api.nvim_set_keymap(
    "n",
    "<A-j>",
    ":cnext<cr>",
    {
        noremap = true,
        silent = true
    }
    )
vim.api.nvim_set_keymap(
    "n",
    "<A-k>",
    ":cprev<cr>",
    {
        noremap = true,
        silent = true
    }
    )

--Do not replace default register when paste over a visual selection
-- vim.api.nvim_set_keymap('n', 'p', '"_dP', { noremap = true, silent = false })

--Map blankline
-- vim.g.indent_blankline_char = '.'
-- vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
-- vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
-- vim.g.indent_blankline_char_highlight = 'LineNr'
-- vim.g.indent_blankline_show_trailing_blankline_indent = false

-- Gitsigns
require(
    "gitsigns"
    ).setup {
    signs = {
        add = {
            hl = "GitGutterAdd",
            text = "+"
        },
        change = {
            hl = "GitGutterChange",
            text = "~"
        },
        delete = {
            hl = "GitGutterDelete",
            text = "_"
        },
        topdelete = {
            hl = "GitGutterDelete",
            text = "‾"
        },
        changedelete = {
            hl = "GitGutterChange",
            text = "~"
        }
    }
}

-- Telescope
local actions = require('telescope.actions')
require(
    "telescope"
    ).setup {
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous
            }
        }
    }
}

--Add leader shortcuts
-- Large WhichKey mappings
local wk =
require(
    "which-key"
    )
-- As an example, we will the create following mappings:
--  * <leader>ff find files
--  * <leader>fr show recent files
--  * <leader>fb Foobar
-- we'll document:
--  * <leader>fn new file
--  * <leader>fe edit file
-- and hide <leader>1

wk.register(
    {
        [" "] = {
            "<cmd>Telescope find_files<cr>",
            "Find File"
        },
        f = {
            name = "file", -- optional group name
            f = {
                "<cmd>Telescope find_files<cr>",
                "Find File"
            }, -- create a binding with label
        },
        b = {
            name = "buffers",
            b = {
                [[<cmd>lua require('telescope.builtin').buffers()<CR>]],
                "List Buffers"
            }
        },
        j = {
            name = "misc",
            ["="] = {
                [[<cmd>normal mqHmwgg=G`wzt`q<cr>]],
                "Indent File"
            },
            u = {
                [[<cmd>MundoToggle<cr>]],
                "Undo Tree"
            },
            m = {
                [[<cmd>MinimapToggle<cr>]],
                "Code Minimap"
            },
            s = {
                [[<cmd>syntac sync fromstart<cr>]],
                "Restart Syntax"
            }
        },
        v = {
            name = "vim",
            r = {
                [[<cmd>source $MYVIMRC<cr>]],
                "Refresh Config"
            },
            e = {
                [[<cmd>e $MYVIMRC<cr>]],
                "Edit Config"
            }
        },
        ["/"] = {
            name = "search",
            ["/"] = {
                [[<cmd>lua require('telescope.builtin').grep_string()<CR>]],
                "Grep Directory"
            },
            e = {
                [[<cmd>NvimTreeToggle<cr>]],
                "Explorer"
            }
        },
        s = {
            name = "subsitute",
            u = {
                [[<cmd>%!uniq]],
                "delete-duplicate-lines"
            },
            ["1"] = {
                [[<cmd>g/^\_$\n\_^$/d<cr>]],
                "clear >1 blank lines"
            },
            ["2"] = {
                [[<cmd>g/^\_$\n\_^$\n\_^$/d<cr>]],
                "clear >2 blank lines"
            },
            ["0"] = {
                [[<cmd>g/^\s*$/d<cr>]],
                "clear all blank lines"
            }
        },
        g = {
            name = "git",
            g = {
                [[<cmd>Git<cr>]],
                "Git"
            }
        },
        t = { [[<cmd>ToggleTerm<cr>]], "Term" },
    },
    { prefix = "<leader>" })

local tree_cb =
require "nvim-tree.config".nvim_tree_callback
vim.g.nvim_tree_bindings = {
    { key = { "<CR>", "o", "<2-LeftMouse>", "l" }, cb = tree_cb( "edit") },
    { key = { "<2-RightMouse>", "<C-]>" }, cb = tree_cb( "cd") },
    { key = "<C-v>", cb = tree_cb( "vsplit") },
    { key = "<C-x>", cb = tree_cb( "split") },
    { key = "<C-t>", cb = tree_cb( "tabnew") },
    { key = "<", cb = tree_cb( "prev_sibling") },
    { key = ">", cb = tree_cb( "next_sibling") },
    { key = "P", cb = tree_cb( "parent_node") },
    { key = { "<BS>", "h" }, cb = tree_cb( "close_node") },
    { key = "<S-CR>", cb = tree_cb( "close_node") },
    { key = "<Tab>", cb = tree_cb( "preview") },
    { key = "K", cb = tree_cb( "first_sibling") },
    { key = "J", cb = tree_cb( "last_sibling") },
    { key = "I", cb = tree_cb( "toggle_ignored") },
    { key = "H", cb = tree_cb( "toggle_dotfiles") },
    { key = "R", cb = tree_cb( "refresh") },
    { key = "a", cb = tree_cb( "create") },
    { key = "df", cb = tree_cb( "remove") },
    { key = "dd", cb = tree_cb( "cut") },
    { key = "r", cb = tree_cb( "rename") },
    { key = "<C-r>", cb = tree_cb( "full_rename") },
    { key = "x", cb = tree_cb( "cut") },
    { key = "c", cb = tree_cb( "copy") },
    { key = "p", cb = tree_cb( "paste") },
    { key = "y", cb = tree_cb( "copy_name") },
    { key = "Y", cb = tree_cb( "copy_path") },
    { key = "gy", cb = tree_cb( "copy_absolute_path") },
    { key = "[c", cb = tree_cb( "prev_git_item") },
    { key = "]c", cb = tree_cb( "next_git_item") },
    { key = "-", cb = tree_cb( "dir_up") },
    { key = "q", cb = tree_cb( "close") },
    { key = "?", cb = tree_cb( "toggle_help") }
}
vim.g.nvim_tree_icons = {
    default = " ",
    symlink = " ",
    git = {
        unstaged = "✗",
        staged = "✓",
        unmerged = "",
        renamed = "➜",
        untracked = "★",
        deleted = "",
        ignored = ""
    },
    folder = {
        arrow_open = "",
        arrow_closed = "",
        default = "",
        open = "",
        empty = "",
        empty_open = "",
        symlink = "",
        symlink_open = ""
    },
    lsp = {
        hint = "",
        info = "",
        warning = "",
        error = ""
    }
}
-- vim.api.nvim_set_keymap('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>sf', [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>sb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>sh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>st', [[<cmd>lua require('telescope.builtin').tags()<CR>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>sp', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>so', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true, silent = true })

-- Highlight on yank
vim.api.nvim_exec(
    [[
  augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
  ]], false)

    -- Y yank until the end of line
    vim.api.nvim_set_keymap( "n", "Y", "y$", { noremap = true }) 
    -- vv visual to end of characters
    vim.api.nvim_set_keymap( "n", "vv", "vg_", { noremap = true })
    -- don't copy white space when using $
    vim.api.nvim_set_keymap( "n", "$", "g_", { noremap = true })

    -- LSP settings
    local nvim_lsp =
    require "lspconfig"
    local on_attach = function(
            _,
            bufnr)
        vim.api.nvim_buf_set_option( bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        local opts = { noremap = true, silent = true }
        vim.api.nvim_buf_set_keymap( bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        vim.api.nvim_buf_set_keymap( bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
        vim.api.nvim_buf_set_keymap( bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
        vim.api.nvim_buf_set_keymap( bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
        vim.api.nvim_buf_set_keymap( bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        vim.api.nvim_buf_set_keymap( bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
        vim.api.nvim_buf_set_keymap( bufnr, "n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
        vim.api.nvim_buf_set_keymap( bufnr, "n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
        vim.api.nvim_buf_set_keymap( bufnr, "n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
        vim.api.nvim_buf_set_keymap( bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        vim.api.nvim_buf_set_keymap( bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        vim.api.nvim_buf_set_keymap( bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
        vim.api.nvim_buf_set_keymap( bufnr, "n", "<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
        vim.api.nvim_buf_set_keymap( bufnr, "n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
        vim.api.nvim_buf_set_keymap( bufnr, "n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
        vim.api.nvim_buf_set_keymap( bufnr, "n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
        vim.api.nvim_buf_set_keymap( bufnr, "n", "<leader>so", [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
        vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
    end

    local capabilities =
    vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    -- Enable the following language servers
    local servers = {
        "clangd",
        "rust_analyzer",
        "pyright",
        "tsserver"
    }
    for _, lsp in ipairs(
        servers
        ) do
        nvim_lsp[
        lsp
        ].setup {
            on_attach = on_attach,
            capabilities = capabilities
        }
    end

    -- Make runtime files discoverable to the server
    local runtime_path = vim.split( package.path, ";")
    table.insert( runtime_path, "lua/?.lua")
    table.insert( runtime_path, "lua/?/init.lua")

    -- Treesitter configuration
    -- Parsers must be installed manually via :TSInstall
    require(
        "nvim-treesitter.configs"
        ).setup {
        ensure_installed = "maintained",
        highlight = {
            enable = true, -- false will disable the whole extension
            additional_vim_regex_highlighting = true
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm"
            }
        },
        indent = {
            enable = false
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
                    ["ic"] = "@class.inner"
                }
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = "@class.outer"
                },
                goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer"
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer"
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer"
                }
            }
        }
    }

    -- Set completeopt to have a better completion experience
    vim.o.completeopt =
    "menuone,noinsert"

    -- Compe setup
    require(
        "compe"
        ).setup {
        source = {
            path = true,
            nvim_lsp = true,
            luasnip = false,
            buffer = true,
            calc = false,
            nvim_lua = true,
            vsnip = false,
            ultisnips = true
        }
    }

    -- Utility functions for compe and luasnip
    local t = function(
            str)
        return vim.api.nvim_replace_termcodes( str, true, true, true)
    end

    local check_back_space = function()
        local col =
        vim.fn.col "." -
        1
        if
            col ==
            0 or
            vim.fn.getline(
                "."
                ):sub(
                col,
                col
                ):match "%s"
            then
            return true
        else
            return false
        end
    end

    vim.g.UltiSnipsExpandTrigger =
    "<nop>"
    -- Use (s-)tab to:
    --- move to prev/next item in completion menuone
    --- jump to prev/next snippet's placeholder
    local luasnip =
    require "luasnip"

    vim.o.completeopt =
    "menuone,noselect"

    _G.tab_complete = function()
        if
            vim.fn.pumvisible() == 1
            then
            return t "<C-n>"
        elseif
            luasnip.expand_or_jumpable()
            then
            return t "<Plug>luasnip-expand-or-jump"
        elseif
            check_back_space()
            then
            return t "<Tab>"
        else
            return vim.fn[ "compe#complete" ]()
        end
    end

    _G.s_tab_complete = function()
        if
            vim.fn.pumvisible() == 1
            then
            return t "<C-p>"
        elseif
            luasnip.jumpable( -1)
            then
            return t "<Plug>luasnip-jump-prev"
        else
            return t "<S-Tab>"
        end
    end

    -- Map tab to the above tab complete functiones
    vim.api.nvim_set_keymap( "i", "<Tab>", "v:lua.tab_complete()", { expr = true })
    vim.api.nvim_set_keymap( "s", "<Tab>", "v:lua.tab_complete()", { expr = true })
    vim.api.nvim_set_keymap( "i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
    vim.api.nvim_set_keymap( "s", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })

    -- Map compe confirm and complete functions
    vim.api.nvim_set_keymap( "i", "<cr>", 'compe#confirm("<cr>")', { expr = true })
    vim.api.nvim_set_keymap( "i", "<c-space>", "compe#complete()", { expr = true })

    vim.cmd( [[
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm(luaeval("require 'nvim-autopairs'.autopairs_cr()"))
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
]])
