local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Remap space as leader key
map("", "<Space>", "<Nop>")
--Remap for dealing with word wrap
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
--Switch windows easier
map("n", "<c-j>", "<c-w>j")
map("n", "<c-h>", "<c-w>h")
map("n", "<c-k>", "<c-w>k")
map("n", "<c-l>", "<c-w>l")
map("n", "<c-l>", "<c-w>l")

-- return to normal window from terminal easily
map("t", "<c-j>", "<C-\\><C-n><c-w>j")
map("t", "<c-k>", "<C-\\><C-n><c-w>k")
map("t", "<c-h>", "<C-\\><C-n><c-w>h")
map("t", "<c-l>", "<C-\\><C-n><c-w>l")
map("t", "<c-n>", "<C-\\><C-n>")

map("v", "p", '"_dP')

--Switch quickfix with alt
map("n", "<A-j>", ":cnext<cr>")
map("n", "<A-k>", ":cprev<cr>")

--Switch buffers with shift-alt
map("n", "<S-A-j>", ":bnext<cr>")
map("n", "<S-A-k>", ":bprev<cr>")

-- H and L move to start and end of the line
map("n", "H", "^")
map("n", "L", "$")

map("n", "<bs>", "<c-^>`”zz") -- switch between buffers with delete
map("n", "Q", "@q") -- no EX mode, execute q macro

-- keep selection on indenting lines
map("v", ">", ">gv")
map("v", "<", "<gv")
map("v", "f", "<cmd>lua require'hop'.hint_words()<cr>")
map("n", "f", "<cmd>lua require'hop'.hint_words()<cr>")

map("n", "Y", "y$") -- Y yank until the end of line
map("n", "vv", "vg_") -- vv visual to end of characters
map("n", "$", "g_") -- don't copy white space when using $

-- keep centered while jumping around in search/J
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "J", "mzJ`z")
map("i", ".", ".<c-g>u")
map("i", "!", "!<c-g>u")
map("i", "?", "?<c-g>u")

map("x", "p", '"_dP')
-- visual select pasted text if in visual mode
map("x", "P", '"_dP `[v`]')

-- Quick grep commands
map("n", "gr", ":grep <cword> *<CR>")
map("n", "gR", ":grep '\b<cword>\b' *<CR>")

--Add leader shortcuts
-- Large WhichKey mappings
local wk = require("which-key")
-- As an example, we will the create following mappings:
--  * <leader>ff find files
--  * <leader>fr show recent files
--  * <leader>fb Foobar
-- we'll document:
--  * <leader>fn new file
--  * <leader>fe edit file
-- and hide <leader>1

wk.register({
  [" "] = {
    '<cmd>lua require"telescope.builtin".find_files({ })<cr>',
    "Find File",
  },
  f = {
    name = "file", -- optional group name
    f = {
      "<cmd>HopWord<cr>",
      "Find File",
    }, -- create a binding with label
    l = {
      "<cmd>HopLine<cr>",
      "Find File",
    }, -- create a binding with label
  },
  b = {
    name = "buffers",
    b = {
      [[<cmd>lua require('telescope.builtin').buffers()<CR>]],
      "List Buffers",
    },
    d = {
      [[<cmd>:bn|:bd#<cr>]],
      "Delete Buffer",
    },
    x = {
      "<cmd>:%bd|e#<cr>",
      "delete-other-buffers",
    },
  },
  j = {
    name = "misc",
    ["="] = {
      [[<cmd>normal mqHmwgg=G`wzt`q<cr>]],
      "Indent File",
    },
    j = {
      [[<cmd>call JenkinsLint()<cr>]],
      "Jenkins Lint",
    },
    u = {
      [[<cmd>MundoToggle<cr>]],
      "Undo Tree",
    },
    s = {
      [[<cmd>syntax sync fromstart<cr>]],
      "Restart Syntax",
    },
  },
  v = {
    name = "vim",
    r = {
      [[<cmd>source $MYVIMRC<cr>]],
      "Refresh Config",
    },
    e = {
      [[<cmd>e $MYVIMRC | cd ~/.config/nvim/ <cr>]],
      "Edit Config",
    },
  },
  ["/"] = {
    name = "search",
    ["/"] = {
      [[<cmd>lua require('telescope.builtin').live_grep{only_sort_text = true}<CR>]],
      "Grep Directory",
    },
    e = {
      [[<cmd>NvimTreeToggle<cr>]],
      "Explorer",
    },
  },
  s = {
    name = "subsitute",
    u = {
      [[<cmd>%!uniq]],
      "delete-duplicate-lines",
    },
    ["1"] = {
      [[<cmd>g/^\_$\n\_^$/d<cr>]],
      "clear >1 blank lines",
    },
    ["2"] = {
      [[<cmd>g/^\_$\n\_^$\n\_^$/d<cr>]],
      "clear >2 blank lines",
    },
    ["0"] = {
      [[<cmd>g/^\s*$/d<cr>]],
      "clear all blank lines",
    },
    ["w"] = {
      [[<cmd>%s/\s\+$//e<cr>]],
      "clear trailing white space",
    },
  },
  g = {
    name = "git",
    g = {
      [[<cmd>Git<cr>]],
      "Git",
    },
    p = {
      [[<cmd>call GitPush()<cr>]],
      "Git Sync",
    },
    d = {
      [[<cmd>Gdiffsplit!<cr>]],
      "Git Diff Split",
    },
  },
  y = {
    f = {
      [[<cmd>let @+ = expand("%")<cr>]],
      "Yank file relative path",
    },
    F = {
      [[<cmd>let @+ = expand("%:p")<cr>]],
      "Yank file full path",
    },
    y = {
      [[<cmd>let @+ = expand("%:t")<cr>]],
      "Yank filename",
    },
    d = {
      [[<cmd>let @+ = expand("%:p:h")<cr>]],
      "Yank directory name",
    },
  },
  t = {
    t = { [[<cmd>ToggleTerm size=10 direction=horizontal<cr>]], "Term Below" },
    l = { [[<cmd>ToggleTerm size=60 direction=vertical<cr>]], "Term Right" },
    h = { [[<cmd>ToggleTerm size=60 direction=vertical<cr>]], "Term Left" },
    j = { [[<cmd>ToggleTerm size=10 direction=horizontal<cr>]], "Term Below" },
    k = { [[<cmd>ToggleTerm direction=float<cr>]], "Term Float" },
  },
}, { prefix = "<leader>" })
