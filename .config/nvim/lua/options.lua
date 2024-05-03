local opt = vim.opt -- to set options

opt.termguicolors = true
opt.encoding = "utf-8"
--Incremental live completion
opt.backspace = { "indent", "eol", "start" }
opt.clipboard = "unnamedplus"
-- Set the clipboard to osc52 if in ssh connection
if os.getenv("SSH_CONNECTION") then
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = require("vim.ui.clipboard.osc52").paste("+"),
			["*"] = require("vim.ui.clipboard.osc52").paste("*"),
		},
	}
end
opt.completeopt = "menu,menuone,noselect"
--Set highlight on search
opt.hlsearch = false
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.inccommand = "split"

--Make line numbers default
opt.relativenumber = true
opt.number = true
opt.hlsearch = false

--Do not save when switching buffers
opt.hidden = true

--Enable mouse mode
opt.mouse = "a"

--Enable break indent
opt.breakindent = true

--Save undo history

--Case insensitive searching UNLESS /C or capital in search
opt.ignorecase = true
opt.smartcase = true

--Decrease update time
opt.updatetime = 250
opt.signcolumn = "yes"
opt.timeoutlen = 300

opt.autoread = true
opt.diffopt = "vertical"
opt.undofile = true
opt.undodir = "~/.config/nvim/undodir"
opt.scrolloff = 5

opt.splitbelow = true
opt.splitright = true

opt.smartindent = false
opt.autoindent = true
opt.cindent = false
opt.indentexpr = ""

opt.signcolumn = "yes:1"
opt.showmode = false
opt.shiftround = true
opt.scrolloff = 4
opt.shiftwidth = 4
opt.list = true
vim.opt.listchars = {
  tab = '· ',
  trail = '·'
}
opt.linebreak = true
opt.joinspaces = false
opt.incsearch = true
opt.formatoptions = "l"
opt.expandtab = true
opt.cursorcolumn = false
opt.wrap = true
opt.cc = "0"
opt.mouse = "a"
opt.guicursor =
"n-v-c-sm:block-blinkwait50-blinkon50-blinkoff50,i-ci-ve:ver25-Cursor-blinkon100-blinkoff100,r-cr-o:hor20"

opt.spell = true

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end
})

-- grep programs
opt.grepprg = "rg --vimgrep --no-heading"
opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"

-- remove ~ symbol from gutter
opt.fillchars:append({ eob = " " })
-- TODO uncomment folding when neovim and treesitter fix vim folding issues
-- opt.foldmethod = 'indent'
-- opt.foldlevelstart = 2
-- opt.foldexpr = 'nvim_treesitter#foldexpr()'
opt.laststatus = 3
opt.mmp = 5000
-- opt.cmdheight = 0
