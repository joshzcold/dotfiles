
call plug#begin()
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'cometsong/commentframe.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'inkarkat/vim-ingo-library'
Plug 'vim-scripts/SyntaxRange'
" Vim LSP plugins
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'Shougo/deoplete.nvim'
Plug 'lighttiger2505/deoplete-vim-lsp'
Plug 'thomasfaingnaert/vim-lsp-snippets'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'
" End Vim LSP Plugins

Plug 'mbbill/undotree'
Plug 'majutsushi/tagbar'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'ludovicchabant/vim-gutentags'
Plug 'godlygeek/tabular'
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
Plug 'mattn/emmet-vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
call plug#end()

" color tweaks
:highlight Pmenu ctermfg=15 ctermbg=235
:highlight PmenuSel ctermfg=15 ctermbg=233
:highlight ErrorMsg ctermfg=15 ctermbg=88 guifg=none guibg=none
:highlight Search ctermfg=235 ctermbg=222

command SudoWrite w !sudo -A tee %

let g:lsp_signs_enabled = 1         " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
let g:deoplete#enable_at_startup = 1
let g:lsp_highlight_references_enabled = 1
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"



let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

let g:lightline = {
      \'colorscheme': 'seoul256',
      \}

let g:ale_lint_on_text_changed = 'never'

" Groovy Tabbar support
let g:tagbar_type_groovy = {
      \ 'ctagstype' : 'groovy',
      \ 'kinds'     : [
      \ 'p:package:1',
      \ 'c:classes',
      \ 'i:interfaces',
      \ 't:traits',
      \ 'e:enums',
      \ 'm:methods',
      \ 'f:fields:1'
      \ ]
      \ }

"------------------------------------------------------------------------------"
"                                 User Hotkeys                                 "
"------------------------------------------------------------------------------"
nmap <C-X> :TagbarToggle<CR>
nmap <C-A> :CocCommand explorer<CR>
nmap <C-S> :GFiles<CR>
" nmap <C-S-u> :UndotreeToggle<CR>
"In neovim, use the option set inccommand=split to
"get an incremental visual feedback when doing the substitude command.
set inccommand=split

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
"set hidden

"" Some servers have issues with backup files, see #649
"set nobackup
"set nowritebackup

"" Better display for messages
"set cmdheight=2

"" You will have bad experience for diagnostic messages when it's default 4000.
"set updatetime=300

"" don't give |ins-completion-menu| messages.
"set shortmess+=c

"" always show signcolumns
"set signcolumn=yes

""navigate completions with tab
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction

"let g:coc_snippet_next = '<tab>'
"" end neoclide/coc-snippets

"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction

"" Use <c-space> to trigger completion.
"inoremap <silent><expr> <c-space> coc#refresh()

"" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
"" Coc only does snippet and additional edit on confirm.
"" <cr> mean Keyboard Enter
"inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

"" Use `[g` and `]g` to navigate diagnostics
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)

"" Remap keys for gotos
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)

"" Use K to show documentation in preview window
"nnoremap <silent> K :call <SID>show_documentation()<CR>

"function! s:show_documentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  else
"    call CocAction('doHover')
"  endif
"endfunction

"" Highlight symbol under cursor on CursorHold
"autocmd CursorHold * silent call CocActionAsync('highlight')


"" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)

"" Remap for do codeAction of current line
"nmap <leader>ac  <Plug>(coc-codeaction)
"" Fix autofix problem of current line
"nmap <leader>qf  <Plug>(coc-fix-current)

"" Create mappings for function text object, requires document symbols feature of languageserver.
"xmap if <Plug>(coc-funcobj-i)
"xmap af <Plug>(coc-funcobj-a)
"omap if <Plug>(coc-funcobj-i)
"omap af <Plug>(coc-funcobj-a)

"" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
"" nmap <silent> <TAB> <Plug>(coc-range-select)
"" xmap <silent> <TAB> <Plug>(coc-range-select)

"" Use `:Format` to format current buffer
"command! -nargs=0 Format :call CocAction('format')

"" Use `:Fold` to fold current buffer
"command! -nargs=? Fold :call     CocAction('fold', <f-args>)

"" use `:OR` for organize import of current buffer
"command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

"" Add status line support, for integration with other plugin, checkout `:h coc-status`
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

"" Using CocList
"" Show all diagnostics
"nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
"" Manage extensions
"nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
"" Show commands
"nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
"" Find symbol of current document
"nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
"" Search workspace symbols
"nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
"" Do default action for next item.
"nnoremap <silent> <space>j  :<C-u>CocNext<CR>
"" Do default action for previous item.
"nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
"" Resume latest coc list
"nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
