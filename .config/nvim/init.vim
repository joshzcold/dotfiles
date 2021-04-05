call plug#begin()
Plug 'itchyny/lightline.vim'                    " replace default Vim status line with something nice
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-fugitive'                       " Very helpful git tool
Plug 'tpope/vim-abolish'                        " some helpful actions like keep case on find, replace
Plug 'tpope/vim-commentary'                     " be able to comment any syntax out
Plug 'tpope/vim-surround'                       " Vim actions to surround word with quotes
Plug 'tpope/vim-sensible'                       " tpope defaults
Plug 'inkarkat/vim-ingo-library'                " Needed for Syntax range
Plug 'vim-scripts/SyntaxRange'                  " Highlight section and color differently
Plug 'chrisbra/Colorizer'                       " Colors Hex codes
Plug 'neoclide/coc.nvim', {'branch': 'release'} " LSP client, ide actions
Plug 'godlygeek/tabular'                        " Tab formatting tool
Plug '/usr/bin/fzf'                                   " fuzzy completion tool
Plug 'junegunn/fzf.vim'                         " fuzzy completion tool
Plug 'stsewd/fzf-checkout.vim'                  " Extra git tool functionality
Plug 'junegunn/limelight.vim'                   " Highlight paragraphs in goyo mode
Plug 'junegunn/goyo.vim'                        " Enable Goyo mode to remove distractions
Plug 'SirVer/ultisnips'                         " custom code snippets manager
Plug 'honza/vim-snippets'                       " Needed for Coc snippets
Plug 'sheerun/vim-polyglot'
"markdown
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim'

" trial plugins. remove full url when accepted
Plug 'https://github.com/liuchengxu/vim-which-key'
Plug 'https://github.com/simnalamburt/vim-mundo'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " treesitter for better syntax highlight
Plug 'nvim-treesitter/playground'
call plug#end()

" put highlights in function incase a plugin sets them and 
" doesn't set them back
function! SetHighlight()
" color tweaks
      :highlight SignColumn ctermbg=none
      :highlight Pmenu ctermfg=15 ctermbg=235
      :highlight PmenuSel ctermfg=15 ctermbg=233
      :highlight ErrorMsg ctermfg=15 ctermbg=88 guifg=none guibg=none
      :hi DiffAdd      ctermfg=22         ctermbg=121
      :hi DiffChange   ctermfg=94        ctermbg=187
      :hi DiffDelete   ctermfg=52         ctermbg=217
      :hi DiffText     ctermfg=24         ctermbg=153
endfunction
:call SetHighlight()

"------------------------------------------------------------------------------"
"                                 User Variables                              "
"------------------------------------------------------------------------------"

"Colorizer Plugin example: ctermbg=100
let g:colorizer_auto_filetype='css,html,cpp,vim,conf'

" lua require'nvim-treesitter.configs'.setup { ensure_installed = "maintained",highlight = { enable = true } }
"

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
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'filetype' ]
      \   ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }
set noshowmode "light line provides mode status

let g:ale_lint_on_text_changed = 'never'

" Limelight/Goyo plugin
let g:limelight_conceal_guifg = 'DarkGray'
let g:limelight_conceal_ctermfg = 'gray'
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight! | :call SetHighlight()

" autoclose using alvan/vim-closetag in these files
let g:closetag_filenames = '*.html, *.svelte, *.js, *.md, *.groovy, Jenkinsfile'

" justinmk/vim-sneak
let g:sneak#label = 1

set autoread " auto load file if it changes on disk
set inccommand=split
set noequalalways " keep window sizes the same when there are changes
set diffopt+=vertical
set autoread
set nohlsearch
set iskeyword+=-
set undofile
set undodir=~/.config/nvim/undodir
set smartcase
set hidden
set updatetime=50
set ignorecase
set scrolloff=5
set nrformats+=alpha "allow increment via Ctrl+a in words
set showmatch matchtime=3 

" set tabstop     =2
" set softtabstop =2
" set shiftwidth  =2
" set expandtab

" line numbers
set number
set relativenumber

" clipboard modification, allows system clipboard
set clipboard+=unnamedplus

" split windows below
set splitbelow

" Needed for coc.nvim
let g:UltiSnipsExpandTrigger = "<nop>"

" Spelling 
set spelllang=en
" set spell for file types
autocmd FileType latex,tex,md,markdown,text setlocal spell

"------------------------------------------------------------------------------"
"                                 User Commands                                "
"------------------------------------------------------------------------------"
" Delete surrounding and keep inner content
command! DeleteEnclosing :normal $%dd''.==
command! JenkinsLint :call JenkinsLint()
command! GPush :call GitPush()
command! CopyFileName let @+ = expand('%:p')

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
" escape from fzf using escape
autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>

"WhichKey mappings
let g:mapleader = "\<Space>"
let g:maplocalleader = ','
set timeoutlen=200
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
call which_key#register('<Space>', "g:which_key_map")
let g:which_key_map =  {}
let g:which_key_map[' '] = [':call fzf#vim#files(".", {"options": "--no-preview"})', 'files']
let g:which_key_map['w'] = {
      \ 'name' : '+windows' ,
      \ 'w' : ['<C-W>w'     , 'other-window']          ,
      \ 'o' : [':only'      , 'close-other-windows']          ,
      \ 'd' : ['<C-W>c'     , 'delete-window']         ,
      \ '-' : ['<C-W>s'     , 'split-window-below']    ,
      \ '|' : ['<C-W>v'     , 'split-window-right']    ,
      \ '2' : ['<C-W>v'     , 'layout-double-columns'] ,
      \ 'h' : ['<C-W>h'     , 'window-left']           ,
      \ 'j' : ['<C-W>j'     , 'window-below']          ,
      \ 'l' : ['<C-W>l'     , 'window-right']          ,
      \ 'k' : ['<C-W>k'     , 'window-up']             ,
      \ 'H' : ['<C-W>5<'    , 'expand-window-left']    ,
      \ 'J' : [':resize +5' , 'expand-window-below']   ,
      \ 'L' : ['<C-W>5>'    , 'expand-window-right']   ,
      \ 'K' : [':resize -5' , 'expand-window-up']      ,
      \ '=' : ['<C-W>='     , 'balance-window']        ,
      \ 's' : ['<C-W>s'     , 'split-window-below']    ,
      \ 'v' : ['<C-W>v'     , 'split-window-below']    ,
      \ '?' : ['Windows'    , 'fzf-window'],
      \ 'V' : [':norm <C-W>t<C-W>H' ,'horizontal->vertical'],
      \ '>' : [':norm <C-W>t<C-W>K' ,'vertical->horizontal']
      \ }

let g:which_key_map.p = {
      \'name': '+project',
      \'a':[':CocCommand explorer','file explorer']
      \}

let g:which_key_map.b = {
      \ 'name' : '+buffer' ,
      \ '1' : ['b1'        , 'buffer 1']        ,
      \ '2' : ['b2'        , 'buffer 2']        ,
      \ 'd' : [':bn|:bd#'        , 'delete-buffer']   ,
      \ 'f' : ['bfirst'    , 'first-buffer']    ,
      \ 'h' : ['Startify'  , 'home-buffer']     ,
      \ 'l' : ['blast'     , 'last-buffer']     ,
      \ 'n' : ['bnext'     , 'next-buffer']     ,
      \ 'p' : ['bprevious' , 'previous-buffer'] ,
      \ 'x' : [':%bd|e#' , 'delete-other-buffers'] ,
      \ 'b' : [':call fzf#vim#buffers({"options": "--no-preview"})','list-buffers']
      \ }

let g:which_key_map.g = {
      \ 'name': '+git'                       ,
      \ 'b' : [':GBranches'                  , 'git-branches']        ,
      \ 'f' : [':GFiles'                     , 'git-files']           ,
      \ 's' : [':GFiles?'    , 'git-files-status'],
      \ 'p' : [':GPush'                      , 'git-push--file']      ,
      \ 'g' : [':vertical G'                 , 'git']                 ,
      \ 'i' : [':Gdiffsplit!'                , 'git-diff']            ,
      \ 'd' : ['<Plug>(coc-definition)'      , 'coc-definition']      ,
      \ '[' : ['<Plug>(coc-diagnostic-prev)' , 'coc-diagnostic-prev'] ,
      \ ']' : ['<Plug>(coc-diagnostic-next)' , 'coc-diagnostic-next'] ,
      \ 'r' : ['<Plug>(coc-references)'      , 'coc-references']
      \}

let g:which_key_map.j ={
      \ 'name': '+misc',
      \ 'n' : [':Snippets'               , 'snippets']     ,
      \ '=' : [':normal mqHmwgg=G`wzt`q' , 'indent-file']  ,
      \ 'g' : [':Goyo 120'               , 'present-code'] ,
      \ 'j' : [':call JenkinsLint()'     , 'jenkins-lint'] ,
      \ 's' : [':call Scratch()'     , 'scratch-buffer'] ,
      \ 'u' : ['MundoToggle'             , 'undo-tree']
      \}

let g:which_key_map.s ={
      \ 'name': '+substitute',
      \ 'd' : {
            \ 'name': '+delete',
            \  '1':[':g/^\_$\n\_^$/d'   , 'clear >1 blank lines'] ,
            \  '2':[':g/^\_$\n\_^$\n\_^$/d', 'clear >2 blank lines'] ,
            \  '0':[':g/^\s*$/d'   ,'clear all blank lines'] ,
            \  'u':[':%!uniq'   ,'delete-duplicate-lines'] ,
            \},
      \}

let g:which_key_map.v ={
      \ 'name': '+vim'            ,
      \ 'r' : [':source $MYVIMRC' , 'refresh-config'] ,
      \ 'e' : [':e $MYVIMRC'      , 'edit-vimrc']
      \}

let g:which_key_map.t ={
      \ 'name': '+term'  ,
      \ 'V' : [':new +resize8 term://zsh'  , 'term-below'],
      \ 't' : [':new +resize8 term://zsh'  , 'term-below'],
      \ '>' : [':vnew term://zsh'  , 'term-right']
      \}

let g:which_key_map.f ={
      \ 'name': '+file'  ,
      \ 'z' : {
            \ 'name': '+fold'  ,
            \ 't': ['za'  , 'toggle-fold (za)'],
            \ 'c': ['zM'  , 'close-all-folds (zM)'],
            \ 'o': ['zR'  , 'open-all-folds (zR)'],
            \},
      \ 's' : {
            \ 'name': '+spell'  ,
            \ ']': ['s]'  , 'next-mispell (s])'],
            \ '[': ['s['  , 'prev-mispell (s[)'],
            \ '=': ['z='  , 'interactive-fix (z=)'],
            \ 'a': ['zg'  , 'add-to-dictionary (zg)'],
            \ 'x': ['zw'  , 'mark-as-misspell (zw)'],
            \},
      \'!' : [':w !sudo -A tee %','sudo-save']
      \}

let g:which_key_map['/'] = {
      \ 'name': '+search'    ,
      \ '/' : [':Rg!'        , 'search-directory']   ,
      \ 'b' : [':Lines'      , 'lines-buffers']      ,
      \ 'l' : [':BLines'     , 'lines-current-file'] ,
      \ 'g' : [':GFiles'     , 'git-files']          ,
      \ 'f' : [':call fzf#vim#files(".", {"options": "--no-preview"})', 'files'],
      \ 'e':[':CocCommand explorer','file explorer'],
      \ 's' : [':GFiles?'    , 'git-files-status']
      \}

let g:which_key_map.k = {
      \'name': '+mmkay',
      \'k':[':norm "kdg_j$"kp','join down break line']
      \}  

let g:which_key_map.y ={
      \'name': '+yank',
      \'y' :['^yg_' , 'yank-line-no-newl'],
      \'f' :["CopyFileName", 'yank-file-path']
      \}

" fzf :Files without preview 
nnoremap <silent> <leader><leader> :call fzf#vim#files('.', {'options': '--no-preview'})<CR>

" rip grep
command! -bang -nargs=* Rgnl
  \ call fzf#vim#grep(
  \   'rg --column --no-heading --no-line-number --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" replace currently selected text with default register
" without yanking it in visual mode
vnoremap p "_dP

" easier return to other windows, preserves Esc in terminal for vi-mode
tnoremap <c-j> <C-\><C-n><c-w>j
tnoremap <c-k> <C-\><C-n><c-w>k
tnoremap <c-h> <C-\><C-n><c-w>h
tnoremap <c-l> <C-\><C-n><c-w>l
" escape
tnoremap <c-n> <C-\><C-n>

au FileType fzf tnoremap <buffer> <c-j> <c-j>
au FileType fzf tnoremap <buffer> <c-k> <c-k>
au FileType fzf tnoremap <buffer> <c-h> <c-h>
au FileType fzf tnoremap <buffer> <c-l> <c-l>

" next quick fix
nnoremap <c-j> <c-w>j
nnoremap <c-h> <c-w>h
nnoremap <A-j> :cnext<CR>
nnoremap <A-k> :cprev<CR>
nnoremap <c-l> <c-w>l
nnoremap <c-k> <c-w>k
" traversal by line wraps
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" to end with character, ignore white space
nnoremap $ g_ 
" capital Y yanks to end of line
nnoremap Y y$

" join like `J` but downwards. uses k register
" vim purists would probably hate this
nnoremap K ^"kdg_"_ddg_a <esc>"kp

"------------------------------------------------------------------------------"
"                                User Functions                                "
"------------------------------------------------------------------------------"

" when reopening a file go to previous line visited
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif
endif

" Should do a quick hightlight on yank
augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

function! GitPush()
  execute("Gwrite")
  let message = input("commit message: ")
  execute("Gcommit -m '".message."' ")
  execute("Gpush")
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

function! Scratch()
    split
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    "setlocal nobuflisted
    "lcd ~
    file scratch
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
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
