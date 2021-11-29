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
        use "https://github.com/williamboman/nvim-lsp-installer"

        use "quangnguyen30192/cmp-nvim-ultisnips"
        use 'hrsh7th/cmp-nvim-lsp'
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/cmp-path'
        use 'hrsh7th/cmp-cmdline'
        use 'hrsh7th/nvim-cmp'
        use 'https://github.com/onsails/lspkind-nvim'
        use 'joshzcold/cmp-jenkinsfile'

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
        use {
            'kyazdani42/nvim-tree.lua',
            requires = 'kyazdani42/nvim-web-devicons'
        }
        use "https://github.com/windwp/nvim-ts-autotag"
        use 'https://github.com/norcalli/nvim-colorizer.lua'                       
        use 'tomasiser/vim-code-dark' 
        use {
            'hoob3rt/lualine.nvim',
            requires = {'kyazdani42/nvim-web-devicons', opt = true},
        }
        use 'https://github.com/phaazon/hop.nvim'
        use 'https://github.com/windwp/nvim-autopairs'
        use 'https://github.com/mhartington/formatter.nvim'
        use 'https://github.com/nvim-lua/lsp-status.nvim'
        use 'https://github.com/glepnir/lspsaga.nvim'
        -- ASCII Drawing Program
        use 'https://github.com/jbyuki/venn.nvim'
    end
    )

vim.cmd [[set termguicolors]]
vim.cmd [[colorscheme codedark]]
vim.cmd ([[ highlight Comment cterm=italic gui=italic ]])
vim.g["minimap_highlight"] = "Comment"

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
      yaml = {prettier},
      sh = {
          -- Shell Script Formatter
       function()
         return {
           exe = "shfmt",
           args = { "-i", 2 },
           stdin = true,
         }
       end,
      }
  }
})

vim.api.nvim_exec([[
augroup FormatAutogroup
  autocmd FileType sh,js,ts,css,scss,md,html,json,yaml 
   \ autocmd! BufWritePost <buffer> :FormatWrite
augroup END
]], true)

require('nvim-autopairs').setup{}
local npairs = require'nvim-autopairs'
local Rule   = require'nvim-autopairs.rule'
local cond = require('nvim-autopairs.conds')

require('nvim-autopairs').remove_rule('"')
require('nvim-autopairs').remove_rule("'")
require('nvim-autopairs').remove_rule("`")

npairs.add_rules {
    Rule("'", "'")
        :with_pair(cond.not_before_regex_check("%S"))
        :with_pair(cond.not_after_regex_check("%S")),
    Rule('"', '"')
        :with_pair(cond.not_before_regex_check("%S"))
        :with_pair(cond.not_after_regex_check("%S")),
  Rule(' ', ' ')
    :with_pair(function (opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ '()', '[]', '{}' }, pair)
    end),
  Rule('( ', ' )')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%)') ~= nil
      end)
      :use_key(')'),
  Rule('{ ', ' }')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%}') ~= nil
      end)
      :use_key('}'),
  Rule('[ ', ' ]')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%]') ~= nil
      end)
      :use_key(']')
}

function GetRepoName()
  local handle = io.popen([[git config --get remote.origin.url | sed 's/.*\/\([^ ]*\/[^.]*\).*/\1/' || true]])
  local result = handle:read("*a")
  if(result)then
      return result.gsub(result, "%s+", "")
  end
  handle:close()
end

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
    lualine_b = {GetRepoName, "branch", "diff" },
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
vim.g.UltiSnipsExpandTrigger = "<NUL>"

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
--Switch buffers with shift-alt
vim.api.nvim_set_keymap( "n", "<S-A-j>", ":bnext<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap( "n", "<S-A-k>", ":bprev<cr>", { noremap = true, silent = true })

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
            "<cmd>lua require\"telescope.builtin\".find_files({ })<cr>",
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
        t = { [[<cmd>ToggleTerm size=120 direction=vertical<cr>]], "Term" },
    },
    { prefix = "<leader>" })

map("v", "f", "<cmd>lua require'hop'.hint_words()<cr>")
map("n", "f", "<cmd>lua require'hop'.hint_words()<cr>")

local tree_cb = require "nvim-tree.config".nvim_tree_callback
require'nvim-tree'.setup {
    update_cwd = true,
    view = {
        auto_resize = true,
        width = 50,
        mappings = {
            list = {
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
        }
    }
}

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
    -- vim.api.nvim_set_keymap( "n", "V", "0vg_", { noremap = true })
    -- don't copy white space when using $
    vim.api.nvim_set_keymap( "n", "$", "g_", { noremap = true })
    -- keep centered while jumping around in search/J
    vim.api.nvim_set_keymap("n", "n", "nzzzv", {noremap = true})
    vim.api.nvim_set_keymap("n", "N", "Nzzzv", {noremap = true})
    vim.api.nvim_set_keymap("n", "J", "mzJ`z", {noremap = true})
    vim.api.nvim_set_keymap("i", ".", ".<c-g>u", {noremap = true})
    vim.api.nvim_set_keymap("i", "!", "!<c-g>u", {noremap = true})
    vim.api.nvim_set_keymap("i", "?", "?<c-g>u", {noremap = true})

    vim.api.nvim_set_keymap("x", "p", '"0p', {noremap = true})
    -- visual select pasted text if in visual mode
    vim.api.nvim_set_keymap("x", "P", '"0p `[v`]', {noremap = true})

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

    -- Setup lspconfig.
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    local lsp_installer = require("nvim-lsp-installer")

    lsp_installer.on_server_ready(function(server)
        local opts = {}

        -- (optional) Customize the options passed to the server
        -- if server.name == "tsserver" then
        --     opts.root_dir = function() ... end
        -- end

        -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
        server:setup(opts)
        vim.cmd [[ do User LspAttachBuffers ]]
    end)
    -- local function setup_servers()
    --     require'lspinstall'.setup()
    --     local servers = require'lspinstall'.installed_servers()
    --     for _, server in pairs(servers) do
    --         require'lspconfig'[server].setup{
    --             capabilities = capabilities
    --         }
    --     end
    -- end

    -- setup_servers()

    -- -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
    -- require'lspinstall'.post_install_hook = function ()
    --     setup_servers() -- reload installed servers
    --     vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
    -- end
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

-- User Functions

vim.cmd [[
au BufRead *.groovy if search('pipeline', 'nw') | setlocal ft=Jenkinsfile | endif

function! GitPush()
      execute("Gwrite")
      let message = input("commit message: ")
      execute("Git commit -m '".message."' ")
      execute("Git pushg")
endfunction

function! JenkinsLint()
      let jenkins_url = "https://10.29.158.99"
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
hi Normal guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
autocmd vimenter * hi SignColumn guibg=NONE ctermbg=NONE
autocmd vimenter * hi LineNr guibg=NONE ctermbg=NONE

au BufRead,BufNewFile *.groovy set filetype=Jenkinsfile

autocmd FileType groovy setlocal commentstring=//\ %s
autocmd FileType Jenkinsfile setlocal commentstring=//\ %s
]]
