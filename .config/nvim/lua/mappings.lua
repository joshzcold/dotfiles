local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Remap space as leader key
map("", "<Space>", "<Nop>")
-- Remap for dealing with word wrap
map("n", "k", [[:MoveWithJumpList k<CR>]], { silent = true, noremap = true })
map("n", "j", [[:MoveWithJumpList j<CR>]], { silent = true, noremap = true })
-- Switch windows easier
map("n", "<c-j>", "<c-w>j")
map("n", "<c-h>", "<c-w>h")
map("n", "<c-k>", "<c-w>k")
map("n", "<c-l>", "<c-w>l")
map("n", "<c-n>", "<c-w>w")

-- Resize windows better
-- map("n", "-", [[:exe "resize " . (winheight(0) * 2/3)<cr>]], { silent = true, desc = "Decrease window size" })
-- map("n", "+", [[:exe "resize " . (winheight(0) * 3/2)<cr>]], { silent = true, desc = "Increase window size" })
-- Switch between tabs
map("n", "<c-t>", ":tabnext<cr>", { silent = true, desc = "Tab next" })
map("n", "<c-y>", ":tabprevious<cr>", { silent = true, desc = "Tab prev" })

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

-- quickly switch git branches with ctrl-b
map("n", "<c-b>", ":lua require('telescope.builtin').git_branches({})<cr>")

-- H and L move to start and end of the line
map("n", "H", "^")
map("n", "L", "$")

map("x", "H", "^")
map("x", "L", "$")

-- map("n", "<bs>", "<c-^>`”zz") -- switch between buffers with delete
map("n", "<bs>", "<c-^>") -- switch between buffers with delete
map("n", "Q", "@q")       -- no EX mode, execute q macro

-- keep selection on indenting lines
map("v", ">", ">gv")
map("v", "<", "<gv")

map("n", "Y", "y$")   -- Y yank until the end of line
map("n", "vv", "vg_") -- vv visual to end of characters
map("n", "$", "g_")   -- don't copy white space when using $

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
map("n", "<esc>", ":noh<return><esc>")

-- leader mappings --
map("n", "<leader>", "", { desc = "" })
-- Helpful yanking y
map("n", "<leader>yy", [[:let @+ = expand("%")<cr>]], { desc = "Yank relative path" })             -- lua/mappings.lua
map("n", "<leader>yf", [[:let @+ = expand("%:t")<cr>]], { desc = "Yank filename" })                -- mappings.lua
map("n", "<leader>yF", [[:let @+ = expand("%:p")<cr>]], { desc = "Yank file full path" })          -- /home/joshua/.config/nvim/lua/mappings.lua
map("n", "<leader>yd", [[:let @+ = expand("%:h")<cr>]], { desc = "Yank directory relative path" }) -- lua
map("n", "<leader>yD", [[:let @+ = expand("%:p:h")<cr>]], { desc = "Yank directory full path" })   -- /home/joshua/.config/nvim/lua
map(
	"n",
	"<leader>yg",
	[[:let @+ = trim(system("git branch --show-current 2>/dev/null"))<cr>]],
	{ desc = "Yank git branch" }
)                                                                                                       -- main|dev|master

map("n", "<leader>yj", [[:let @+=luaeval('require"jsonpath".get()')<cr>]], { desc = "Yank json path" }) -- .path.to.json.object

map(
	"n",
	"<leader>yR",
	[[:let @a='' | %s/regex/\=setreg('A', submatch(0) . "\n")/n<c-f> ]],
	{ desc = "Yank regex capture group" }
)
map(
	"x",
	"<leader>yR",
	[[:let @a='' | '<,'>s/regex/\=setreg('A', submatch(0) . "\n")/n<c-f> ]],
	{ desc = "Yank regex capture group" }
)

-- substitute s
map("n", "<leader>su", ":%!uniq<cr>", { desc = "Delete duplicate lines" })
map("n", "<leader>s1", [[:g/^\_$\n\_^$/d<cr>]], { desc = "Clear >1 blank lines" })
map("n", "<leader>s2", [[:g/^\_$\n\_^$\n\_^$/d<cr>]], { desc = "Clear >2 blank lines" })
map("n", "<leader>s0", [[:g/^\s*$/d<cr>]], { desc = "Clear all blank lines" })
map("n", "<leader>sw", [[:%s/\s\+$//e<cr>]], { desc = "Clear all blank lines" })

-- make m
map("n", "<leader>mm", ":make<cr>", { desc = "Make" })
map("n", "<leader>m,", "f,li<CR><Esc>lq", { desc = "(macro) split comma to newline" })
map("n", "<leader>m\\", [[Wi\<CR><Esc>l]], { desc = "(macro) split shell by \\" })
map(
	"n",
	"<leader>mf",
	[[/format<CR>f(lv/,\|)<CR>lhd0/{\d}<CR>lvp<Esc>0]],
	{ desc = "(macro) convert python format string to fstring partially" }
)

-- vim v
map("n", "<leader>vr", ":source $MYVIMRC", { desc = "Source Config" })
map("n", "<leader>ve", ":e $MYVIMRC | cd ~/.config/nvim/ <cr>", { desc = "Edit Config" })

-- misc j
map("n", "<leader>j=", ":normal mqHmwgg=G`wzt`q<cr>", { desc = "Indent file" })
map("n", "<leader>js", ":syntax sync fromstart<cr>", { desc = "Restart Syntax" })

-- buffers b
map("n", "<leader>bd", ":bn|:bd#<cr>", { desc = "Delete Buffer" })
map("n", "<leader>bx", ":%bd|e#<cr>", { desc = "Delete All Other Buffers" })

-- git g

map("n", "<leader>gp", ":GitPush<cr>", { desc = "Git Sync" })
map("n", "<leader>gP", ":!open_review.sh<cr>", { desc = "Open Pull Request" })
map("n", "<leader>gr", ":GitPushWithReview<cr>", { desc = "Git Sync with review" })
map("n", "<leader>gu", ":Git pull<cr>", { desc = "Git pull" })

-- Profiling
map("n", "<leader>vps", "", {
	desc = "Profile Start",
	callback = function()
		vim.cmd([[
		:profile start /tmp/nvim-profile.log
		:profile func *
		:profile file *
	]])
	end,
})

map("n", "<leader>vpe", "", {
	desc = "Profile End",
	callback = function()
		vim.cmd([[
		:profile stop
		:e /tmp/nvim-profile.log
	]])
	end,
})
