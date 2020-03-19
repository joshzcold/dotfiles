
call plug#begin()
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'cometsong/commentframe.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'inkarkat/vim-ingo-library'
Plug 'vim-scripts/SyntaxRange'
Plug 'mbbill/undotree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'godlygeek/tabular'
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
:highlight Search ctermfg=235 ctermbg=222

command SudoWrite w !sudo -A tee %

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

let g:lightline = {
      \'colorscheme': 'seoul256',
      \}

let g:ale_lint_on_text_changed = 'never'

"------------------------------------------------------------------------------"
"                                 User Hotkeys                                 "
"------------------------------------------------------------------------------"
nmap <C-A> :CocCommand explorer<CR>
nmap <C-S> :GFiles<CR>
nmap <C-C> :Rg<CR>
nmap <silent> gd :AnyJump<CR>
" nmap <C-S-u> :UndotreeToggle<CR>
"In neovim, use the option set inccommand=split to
"get an incremental visual feedback when doing the substitude command.
set inccommand=split
set diffopt+=vertical

" line numbers
set number
set relativenumber

" clipboard modification
set clipboard+=unnamedplus
" split windows below
set splitbelow
" " tab settings change to 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab     "expand tabs to spaces

" Needed for coc.nvim
let g:UltiSnipsExpandTrigger = "<nop>"
"===================================================================
" coc.nvim configuration
"===================================================================
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

let g:coc_snippet_next = '<tab>'
" end neoclide/coc-snippets

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

" Remap keys for gotos
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" nmap <silent> <TAB> <Plug>(coc-range-select)
" xmap <silent> <TAB> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
