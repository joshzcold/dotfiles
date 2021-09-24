local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
-- Install packer
local install_path = vim.fn.stdpath "data" ..  "/site/pack/packer/start/packer.nvim"

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
require( "packer").use
require( "packer").startup(
    function()
        use "wbthomason/packer.nvim" -- Package manager
        use "tpope/vim-fugitive" -- Git commands in nvim
        use "tpope/vim-rhubarb" -- Fugitive-companion to interact with github
        use "tpope/vim-commentary" -- "gc" to comment visual regions/lines
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
        -- use "itchyny/lightline.vim" -- Fancier statusline
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
        use "https://github.com/kabouzeid/nvim-lspinstall"

        -- use "hrsh7th/nvim-compe" -- Autocompletion plugin
        use "https://github.com/joshzcold/nvim-compe" -- Autocompletion plugin

        use "L3MON4D3/LuaSnip" -- Snippets plugin
        use "windwp/nvim-autopairs" -- Autopair characters
        use "folke/which-key.nvim" -- emacs style leader preview
        use "simnalamburt/vim-mundo"
        use "https://github.com/godlygeek/tabular"

        use "SirVer/ultisnips" -- custom code snippets manager
        use "honza/vim-snippets" -- lots of pre-made snippets
        use "tpope/vim-surround" -- Vim actions to surround word with quotes
        use "sheerun/vim-polyglot"
        use "iamcco/markdown-preview.nvim"
        use "neo4j-contrib/cypher-vim-syntax"

        use "https://github.com/Pocco81/TrueZen.nvim"
        use "https://github.com/akinsho/nvim-toggleterm.lua"
        use "wfxr/minimap.vim"

        use "kyazdani42/nvim-web-devicons"
        use "https://github.com/kyazdani42/nvim-tree.lua"
        use "https://github.com/windwp/nvim-ts-autotag"
        use 'https://github.com/norcalli/nvim-colorizer.lua'                       
        use 'tomasiser/vim-code-dark' 
        use 'https://github.com/joshzcold/DrawIt'
        use {
            'hoob3rt/lualine.nvim',
            requires = {'kyazdani42/nvim-web-devicons', opt = true},
        }
        use 'https://github.com/phaazon/hop.nvim'

        use 'https://github.com/mhartington/formatter.nvim'
        use 'https://github.com/nvim-lua/lsp-status.nvim'
        use 'https://github.com/glepnir/lspsaga.nvim'
        use 'https://github.com/kristijanhusak/orgmode.nvim'
        -- ASCII Drawing Program
        use 'https://github.com/jbyuki/venn.nvim'
        use 'https://github.com/lervag/vimtex'
    end
    )

vim.cmd [[set termguicolors]]
vim.cmd [[colorscheme codedark]]
vim.cmd ([[ highlight Comment cterm=italic gui=italic ]])
vim.g["minimap_highlight"] = "Comment"

require('orgmode').setup({
  org_agenda_files = {'~/git/org/*'},
  org_default_notes_file = '~/git/org/refile.org',
})

local prettier = function()
  return {
    exe = "prettier",
    args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--double-quote"},
    stdin = true
  }
end

require('formatter').setup({
  logging = false,
  filetype = {
      javascript = {prettier},
      typescript = {prettier},
      html = {prettier},
      css = {prettier},
      scss = {prettier},
      markdown = {prettier},
      json = {prettier},
      yaml = {prettier}
  }
})

vim.api.nvim_exec([[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.ts,*.css,*.scss,*.md,*.html,*.json,*.yaml : FormatWrite
augroup END
]], true)

require('hop').setup()
require "lualine".setup {
 options = {
    icons_enabled = true,
    theme = "codedark",
    component_separators = {"∙", "∙"},
    section_separators = {"", ""},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {"mode", "paste"},
    lualine_b = {"branch", "diff"},
    lualine_c = {
      {"filename", file_status = true, full_path = true},
      require "lsp-status".status
    },
    lualine_x = {"filetype"},
    lualine_y = {
      {
        "progress"
      }
    },
    lualine_z = {
      {
        "location",
        icon = ""
      }
    }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {"filename"},
    lualine_x = {"location"},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
require( "nvim-autopairs").setup( {
        disable_filetype = {
            "TelescopePrompt",
            "vim"
        }
    })

local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

parser_configs.norg = {
    install_info = {
        url = "https://github.com/vhyrro/tree-sitter-norg",
        files = { "src/parser.c" },
        branch = "main"
    },
}

require 'colorizer'.setup()

require( "nvim-ts-autotag").setup()

--Incremental live completion
vim.o.inccommand = "split"
vim.g.UltiSnipsExpandTrigger = "<cr>"


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
-- vim.g.lightline = {
--     colorscheme = "codedark",
--     active = {
--         left = {
--             {
--                 "mode",
--                 "paste"
--             },
--             {
--                 "gitbranch",
--                 "readonly",
--                 "filename",
--                 "modified"
--             }
--         }
--     },
--     component_function = {
--         gitbranch = "fugitive#head"
--     }
-- }

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
vim.api.nvim_set_keymap( "n", "<A-j>", ":cnext<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap( "n", "<A-k>", ":cprev<cr>", { noremap = true, silent = true })

-- H and L move to start and end of the line
vim.api.nvim_set_keymap("n", "H", "^", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "L", "$", {noremap = true, silent = true})

-- switch between buffers with delete
vim.api.nvim_set_keymap("n", "<bs>", "<c-^>`”zz", {noremap = true, silent = true})

-- no EX mode, execute q macro
vim.api.nvim_set_keymap("n", "Q", "@q", {noremap = true, silent = true})

-- keep selection on indenting lines
vim.api.nvim_set_keymap("v", ">", ">gv", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<", "<gv", {noremap = true, silent = true})

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
local action_state = require("telescope.actions.state")
local custom_actions = {}

function custom_actions.fzf_multi_select(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local num_selections = table.getn(picker:get_multi_selection())

    if num_selections > 1 then
        -- actions.file_edit throws - context of picker seems to change
        --actions.file_edit(prompt_bufnr)
        actions.send_selected_to_qflist(prompt_bufnr)
        actions.open_qflist()
    else
        actions.file_edit(prompt_bufnr)
    end
end
require( "telescope").setup {
    pickers = {
        find_files = {
            previewer = false,
        },
        buffers = {
            previewer = false,
        }
    },
    defaults = {
        mappings = {
            i = {
                -- close on escape
                ["<esc>"] = actions.close,
                ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
                ["<cr>"] = custom_actions.fzf_multi_select
            },
            n = {
                ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
                ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
                ["<cr>"] = custom_actions.fzf_multi_select
            }
        }
    }
}

function _G.toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled) 
    if(venn_enabled == "nil") then
        vim.b.venn_enabled = true
        vim.cmd[[setlocal ve=all]]
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<cr>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<cr>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<cr>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<cr>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<cr>", {noremap = true})
    else
        vim.cmd[[setlocal ve=]]
        vim.cmd[[mapclear <buffer>]]
        vim.b.venn_enabled = nil
    end

end
-- toggle keymappings for venn
vim.api.nvim_set_keymap('n', '<leader>dz', ":lua toggle_venn()<cr>", { noremap = true})

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
            "<cmd>lua require\"telescope.builtin\".find_files({ hidden = true })<cr>",
            "Find File"
        },
        f = {
            name = "file", -- optional group name
            f = {
                "<cmd>HopWord<cr>",
                "Find File"
            }, -- create a binding with label
            l = {
                "<cmd>HopLine<cr>",
                "Find File"
            }, -- create a binding with label
        },
        b = {
            name = "buffers",
            b = {
                [[<cmd>lua require('telescope.builtin').buffers()<CR>]],
                "List Buffers"
            },
            d = {
                [[<cmd>:bn|:bd#<cr>]],
                "Delete Buffer"
            },
            x = {
                '<cmd>:%bd|e#<cr>' ,
                'delete-other-buffers'
            }
        },
        j = {
            name = "misc",
            ["="] = {
                [[<cmd>normal mqHmwgg=G`wzt`q<cr>]],
                "Indent File"
            },
            j = {
                [[<cmd>call JenkinsLint()<cr>]],
                "Jenkins Lint"
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
                [[<cmd>syntax sync fromstart<cr>]],
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
                [[<cmd>lua require('telescope.builtin').live_grep{only_sort_text = true}<CR>]],
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
            },
            p = {
                [[<cmd>call GitPush()<cr>]],
                "Git Sync"
            },
            d = {
                [[<cmd>Gdiffsplit!<cr>]],
                "Git Diff Split"
            }
        },
        t = { [[<cmd>ToggleTerm<cr>]], "Term" },
    },
    { prefix = "<leader>" })

map("v", "<leader>ff", "<cmd>lua require'hop'.hint_words()<cr>")
map("v", "<leader>fl", "<cmd>lua require'hop'.hint_lines()<cr>")

local tree_cb =
require "nvim-tree.config".nvim_tree_callback
vim.g.nvim_tree_update_cwd = 1
vim.g.nvim_tree_follow = 1
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
    -- keep centered while jumping around in search/J
    vim.api.nvim_set_keymap("n", "n", "nzzzv", {noremap = true})
    vim.api.nvim_set_keymap("n", "N", "Nzzzv", {noremap = true})
    vim.api.nvim_set_keymap("n", "J", "mzJ`z", {noremap = true})
    -- undo breakpoints while inserting text
    vim.api.nvim_set_keymap("i", ",", ",<c-g>u", {noremap = true})
    vim.api.nvim_set_keymap("i", ".", ".<c-g>u", {noremap = true})
    vim.api.nvim_set_keymap("i", "!", "!<c-g>u", {noremap = true})
    vim.api.nvim_set_keymap("i", "?", "?<c-g>u", {noremap = true})

    -- LSP settings
    local nvim_lsp = require('lspconfig')

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        --Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = { noremap=true, silent=true }

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

    end
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    require'lspinstall'.setup() -- important

    local servers = require'lspinstall'.installed_servers()
    for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
            on_attach = on_attach,
            flags = {
                debounce_text_changes = 150,
            }
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
    vim.o.completeopt = "menuone,noselect"
    -- Compe setup
    require("compe").setup ({
        allow_hidden_buffers = true,
        source = {
            ultisnips = true,
            path = true,
            nvim_lsp = true,
            orgmode = true,
            tags = true,
            spell = true,
            calc = true,
            luasnip = false,
            buffer = true,
            nvim_lua = true,
            vsnip = false
        }
    })

    -- Utility functions for compe and luasnip 
    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    local check_back_space = function()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
    end

    -- Use (s-)tab to:
    --- move to prev/next item in completion menuone
    --- jump to prev/next snippet's placeholder

    _G.tab_complete = function()
        if
            vim.fn.pumvisible() == 1
            then
            return t "<C-n>"
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
    vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm({ 'keys': '<CR>', 'select': v:true })", { expr = true })

    vim.cmd([[
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm(luaeval("require 'nvim-autopairs'.autopairs_cr()"))
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
]])
-- User Functions

vim.cmd [[
au BufRead *.groovy if search('pipeline', 'nw') | setlocal ft=Jenkinsfile | endif
function! GitPush()
      execute("Gwrite")
      let message = input("commit message: ")
      execute("Git commit -m '".message."' ")
      execute("Git push")
endfunction

function! JenkinsLint()
      let jenkins_url = "https://vlab055512.dom055500.lab/jenkins"
      let crumb_command = "curl -s -k \"".jenkins_url.'/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)"'
      let jenkins_crumb = system(crumb_command)
      let validate_command = "curl -k -X POST -H ".jenkins_crumb." -F \"jenkinsfile=<".expand('%:p')."\" ".jenkins_url."/pipeline-model-converter/validate"
      echo validate_command
      let result = system(validate_command)
      echo result
endfunction
]]

-- highlighting tweaks
vim.cmd [[
hi DiffAdd ctermfg=none guifg=#007504 guibg=none ctermbg=none
hi DiffChange ctermfg=none guifg=#a37500 guibg=none ctermbg=none
hi DiffDelete ctermfg=none guifg=#7a0000 guibg=none ctermbg=none

]]

