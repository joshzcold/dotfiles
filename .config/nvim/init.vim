call plug#begin()
Plug 'itchyny/lightline.vim'                    " replace default Vim status line with something nice
Plug 'tpope/vim-fugitive'                       " Very helpful git tool
Plug 'stsewd/fzf-checkout.vim'                  " Extra git tool functionality
Plug 'tpope/vim-abolish'                        " some helpful actions like keep case on find, replace
Plug 'tpope/vim-commentary'                     " be able to comment any syntax out
Plug 'tpope/vim-surround'                       " Vim actions to surround word with quotes
Plug 'inkarkat/vim-ingo-library'                " Needed for Syntax range
Plug 'vim-scripts/SyntaxRange'                  " Highlight section and color differently
Plug 'chrisbra/Colorizer'                       " Colors Hex codes
Plug 'neoclide/coc.nvim', {'branch': 'release'} " LSP client, ide actions
Plug 'sheerun/vim-polyglot'                     " Syntax Highlighting
Plug 'godlygeek/tabular'                        " Tab formatting tool
Plug 'mbbill/undotree'                          " Undo file tool
Plug '~/.fzf'                                   " fuzzy completion tool
Plug 'junegunn/fzf.vim'                         " fuzzy completion tool
Plug 'junegunn/limelight.vim'                   " Highlight paragraphs in goyo mode
Plug 'junegunn/goyo.vim'                        " Enable Goyo mode to remove distractions
Plug 'SirVer/ultisnips'                         " custom code snippets manager
Plug 'honza/vim-snippets'                       " Needed for Coc snippets
Plug 'pechorin/any-jump.vim'                    " search for code definition using a ripgrep search
call plug#end()

" color tweaks
:highlight SignColumn ctermbg=none
:highlight Pmenu ctermfg=15 ctermbg=235
:highlight PmenuSel ctermfg=15 ctermbg=233
:highlight ErrorMsg ctermfg=15 ctermbg=88 guifg=none guibg=none
:hi DiffAdd      ctermfg=22         ctermbg=121
:hi DiffChange   ctermfg=94        ctermbg=187
:hi DiffDelete   ctermfg=52         ctermbg=217
:hi DiffText     ctermfg=24         ctermbg=153
"Colorizer Plugin
let g:colorizer_auto_filetype='css,html,cpp,vim,conf'

let g:coc_global_extensions = [
      \'coc-markdownlint',
      \'coc-highlight',
      \'coc-go',
      \'coc-tsserver',
      \'coc-python',
      \'coc-explorer',
      \]
:highlight Search ctermfg=235 ctermbg=222


let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

let g:fzf_branch_actions = {
      \ 'track': {
      \   'prompt': 'Track> ',
      \   'execute': 'echo system("{git} checkout --track {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-t',
      \   'required': ['branch'],
      \   'confirm': v:false,
      \ },
      \}

let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }
let g:ale_lint_on_text_changed = 'never'

" Limelight plugin
let g:limelight_conceal_guifg = 'DarkGray'
let g:limelight_conceal_ctermfg = 'gray'
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

set inccommand=split
set diffopt+=vertical
set nohlsearch
set iskeyword+=-
set undofile
set undodir=~/.config/nvim/undodir
set smartcase
set hidden
set updatetime=50
set smartindent
set ignorecase
"set termguicolors
set scrolloff=5
set showmatch matchtime=3 

" line numbers
set number
set relativenumber

" clipboard modification
set clipboard+=unnamedplus

" split windows below
set splitbelow

" tab settings change to 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab     "expand tabs to spaces

" Needed for coc.nvim
let g:UltiSnipsExpandTrigger = "<nop>"

"------------------------------------------------------------------------------"
"                                 User Commands                                "
"------------------------------------------------------------------------------"
" attempt to write the file with sudo 
command SudoWrite w !sudo -A tee %
command CypressOpen !./node_modules/cypress/bin/cypress open &
" Push a change just on current file with no intervention
command GPSquash :Gwrite <bar>:Gcommit -m "pipeline small tweak, (REBASE SQUASH)" <bar>:Gpush
command GPDelete :Gwrite <bar>:Gcommit -m "pipeline small tweak, (REBASE DROP)" <bar>:Gpush
" Delete surrounding and keep inner content
command DeleteEnclosing :normal $%dd''.==
command RefreshConfig :source $MYVIMRC
command EditConfig :e $MYVIMRC
command JenkinsLint :call JenkinsLint()

"------------------------------------------------------------------------------"
"                              User Insert Config                              "
"------------------------------------------------------------------------------"
" auto pairing
" Move back into pair
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>

"Auto pair common pairings, if on second part of pair then move out of pair
inoremap <expr> ) matchstr(getline('.'), '\%' . col('.') . 'c.') == ')' ? '<Esc>la' : ')'
inoremap <expr> ] matchstr(getline('.'), '\%' . col('.') . 'c.') == ']' ? '<Esc>la' : ']'
inoremap <expr> } matchstr(getline('.'), '\%' . col('.') . 'c.') == '}' ? '<Esc>la' : '}'
inoremap <expr> <CR> matchstr(getline('.'), '\%' . col('.') . 'c.') == '}' ? '<Space><BS><CR><Space><BS><CR><Esc>ka<Tab>' : '<Space><BS><CR>'

"------------------------------------------------------------------------------"
"                                 User Hotkeys                                 "
"------------------------------------------------------------------------------"
let mapleader = " "
" fzf git files
nmap <leader>f :GFiles<CR>
" rip grep
nmap <leader>d :Rg<CR> 
nmap <leader>s :CocCommand explorer<CR>
nmap <leader>gc :GBranches<CR>
nmap <leader>gg :G<CR>
nmap <leader>gh :diffget //3<CR>
nmap <leader>gu :diffget //2<CR>
nmap <leader>gd :call JumpToDefinition()<CR>
nmap <leader>jf :call JenkinsLint()<CR>
nmap <leader>u :UndotreeToggle<CR> <C-w><C-w>
" easy switch windows
nnoremap <c-j> <c-w>j
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
nnoremap <c-k> <c-w>k
" traversal by line wraps
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
set spelllang=en
autocmd BufRead,BufNewFile *.md, *txt, COMMIT_EDITMSG setlocal spell

"------------------------------------------------------------------------------"
"                                User Functions                                "
"------------------------------------------------------------------------------"

" Should do a quick hightlight on yank
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

function! JumpToDefinition()
   let s = execute("normal \<Plug>(coc-definition)") 
   if strtrans(s)=="^@[coc.nvim]Definition provider not found for current document^@[coc.nvim]Definition provider not found for current document"
    execute "AnyJump"
   endif
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

"------------------------------------------------------------------------------"
"                                CoC.vim Config                                "
"------------------------------------------------------------------------------"

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup
set noswapfile

" Better display for messages
set cmdheight=2

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

"navigate completions with tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
" <cr> mean Keyboard Enter
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
