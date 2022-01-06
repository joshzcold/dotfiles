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

-- don't populate registers on paste
-- visual select pasted text if in visual mode
map("x", "p", "pgvy `[v`]")

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
map("v", "f", ":HopChar1<cr>")
map("n", "f", ":HopChar1<cr>")

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

-- Quick grep commands
map("n", "gr", ":grep <cword> *<CR>")
map("n", "gR", ":grep '\b<cword>\b' *<CR>")
