
call plug#begin()
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'cometsong/commentframe.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'inkarkat/vim-ingo-library'
Plug 'vim-scripts/SyntaxRange'
Plug 'mbbill/undotree'
Plug 'chrisbra/Colorizer'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'godlygeek/tabular'
Plug 'mbbill/undotree'
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'pechorin/any-jump.vim'
call plug#end()

" color tweaks
:highlight Pmenu ctermfg=15 ctermbg=235
:highlight PmenuSel ctermfg=15 ctermbg=233
:highlight ErrorMsg ctermfg=15 ctermbg=88 guifg=none guibg=none

let g:colorizer_auto_filetype='css,html,cpp,vim'

let g:coc_global_extensions = [
      \'coc-markdownlint',
      \'coc-highlight',
      \'coc-go',
      \'coc-tsserver',
      \'coc-python',
      \'coc-explorer',
      \]
:highlight Search ctermfg=235 ctermbg=222

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

let g:lightline = {
      \'colorscheme': 'seoul256',
      \}
let g:ale_lint_on_text_changed = 'never'

"In neovim, use the option set inccommand=split to
"get an incremental visual feedback when doing the substitude command.
set inccommand=split
set diffopt+=vertical
set nohlsearch
set undofile
set undodir=~/.config/nvim/undodir
set smartcase
set ignorecase
set scrolloff=5

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
command Gsync :Gwrite <bar>:Gcommit -m "pipeline small tweak, (REBASE SQUASH)" <bar>:Gpush
" Delete surrounding and keep inner content
command DeleteEnclosing :normal $%dd''.==
command RefreshConfig :source $MYVIMRC
command! -range FormatShellCmd <line1>!format_shell_cmd.py
command IndentFile :normal gg=G<C-o>



"------------------------------------------------------------------------------"
"                              User Insert Config                              "
"------------------------------------------------------------------------------"
" auto pairing
inoremap (<CR> (<CR>)<C-c>O
inoremap {<CR> {<CR>}<C-c>O
inoremap [<CR> [<CR>]<C-c>O
inoremap (;<CR> (<CR>);<C-c>O
inoremap (,<CR> (<CR>),<C-c>O
inoremap {;<CR> {<CR>};<C-c>O
inoremap {,<CR> {<CR>},<C-c>O
inoremap [;<CR> [<CR>];<C-c>O
inoremap [,<CR> [<CR>],<C-c>O
"------------------------------------------------------------------------------"
"                                 User Hotkeys                                 "
"------------------------------------------------------------------------------"
" file explorer
nmap <C-A> :CocCommand explorer<CR>
" fzf git files
nmap <C-S> :GFiles<CR>
" rip grep
nmap <C-C> :Rg<CR> 
nmap <silent>gd :call JumpToDefinition()<CR>
nmap U :UndotreeToggle<CR> <C-w><C-w>
" easy switch windows
nnoremap <c-j> <c-w>j
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
nnoremap <c-k> <c-w>k
" traversal by line wraps
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
set spelllang=en
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.txt setlocal spell
autocmd BufRead,BufNewFile COMMIT_EDITMSG setlocal spell


"------------------------------------------------------------------------------"
"                                User Functions                                "
"------------------------------------------------------------------------------"

function! JumpToDefinition()
   let s = execute("normal \<Plug>(coc-definition)") 
   if strtrans(s)=="^@[coc.nvim]Definition provider not found for current document^@[coc.nvim]Definition provider not found for current document"
    execute "AnyJump"
   endif
endfunction

"------------------------------------------------------------------------------"
"                                CoC.vim Config                                "
"------------------------------------------------------------------------------"
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

"navigate completions with tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
" <cr> mean Keyboard Enter
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction



" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
