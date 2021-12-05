local opt = vim.opt -- to set options

vim.g.UltiSnipsExpandTrigger = "<NUL>"

opt.termguicolors = true
vim.cmd([[colorscheme codedark]])

opt.encoding = "utf-8"
--Incremental live completion
opt.inccommand = "nosplit"
opt.backspace = { "indent", "eol", "start" }
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
--Set highlight on search
opt.hlsearch = false
opt.swapfile = false
opt.backup = false
opt.writebackup = false

--Make line numbers default
opt.relativenumber = true

--Do not save when switching buffers
opt.hidden = true

--Enable mouse mode
opt.mouse = "a"

--Enable break indent
opt.breakindent = true

--Save undo history
opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
opt.ignorecase = true
opt.smartcase = true

--Decrease update time
opt.updatetime = 250
opt.signcolumn = "yes"

opt.autoread = true
opt.diffopt = "vertical"
opt.undodir = "/home/joshua/.config/nvim/undodir"
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
opt.linebreak = true
opt.joinspaces = false
opt.incsearch = true
opt.formatoptions = "l"
opt.expandtab = true
opt.cursorcolumn = true
opt.wrap = true
opt.cc = "120"
opt.mouse = "a"
opt.guicursor =
  "n-v-c-sm:block-blinkwait50-blinkon50-blinkoff50,i-ci-ve:ver25-Cursor-blinkon100-blinkoff100,r-cr-o:hor20"

vim.cmd("au TextYankPost * lua vim.highlight.on_yank {on_visual = true}") -- disabled in visual mode
vim.cmd([[ highlight Comment cterm=italic gui=italic ]])

-- grep programs
opt.grepprg = "rg --vimgrep --no-heading"
opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
