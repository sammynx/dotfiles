" Parent group for all autocommands
" this will remove all autocmd myVimrcs om resourcing .vimrc
augroup myVimrc
	autocmd!
augroup END

" General settings {{{

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set shell=/usr/bin/bash
set autowrite

let maplocalleader = ","

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Syntax highlighting
filetype plugin indent on
syntax on

set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set background=dark

" Finding Files:
" Display all matching files when we tab complete
set wildmenu
set wildignorecase
set wildmode=longest,list,full

" Search down into subfolders
" Provides file completion for all file related tasks
" Now we can:
" - Hit tab to :find by partial match
" - Use * to make it fuzzy
set path+=**

" Jump to the word while typing
set incsearch

" Highlight searches
set hlsearch

" Continue searching from the top when hitting the bottom
set wrapscan

" Always show commands
" set showcmd

" Keep the cursur in the middle
set scrolloff=999

" Tweaks for filebrowsing with netrw
let g:netrw_banner=0        "Disable annoying banner
let g:netrw_liststyle=3     "Tree view
let g:netrw_browse_split=4  "Open in prior window

" Taglist 
let Tlist_Compact_Format = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select = 1

" }}}

" Vim-Plug ----------------------------------------------- {{{

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'govim/govim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'SirVer/ultisnips'
Plug 'arzg/vim-substrata'

" Initialize plugin system
call plug#end()
" }}}

" General Mappings {{{

" Remap the ex-mode key.
nnoremap ; :

" Buffer navigation
nnoremap gb :ls<CR>:buffer<Space>
nnoremap gB :ls<CR>:vertical rightbelow sbuffer<Space>

" Cut/Copy/Paste
vnoremap <C-c> "+yi
vnoremap <C-x> "+c
vnoremap <C-v> c<ESC>"+p
inoremap <C-v> <C-r><C-o>+

" Copy/Paste to the system clipboard
vnoremap <leader>y "+y
nnoremap <leader>p "+p

nnoremap <leader>n :setlocal relativenumber!<cr>

" }}}

" Commands {{{

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" }}}

" Filetype Settings ---------------------- {{{

autocmd myVimrc FileType vim setlocal foldmethod=marker
autocmd myVimrc FileType vim setlocal foldlevelstart=0

autocmd myVimrc FileType sh setlocal foldmethod=marker
autocmd myVimrc FileType sh setlocal foldlevelstart=0

autocmd myVimrc FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd myVimrc FileType c setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd myVimrc FileType cpp setlocal shiftwidth=2 tabstop=2

" force markdown filetype on .md
autocmd myVimrc BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

autocmd myVimrc FileType c nnoremap <C-l> :TlistToggle<CR>

" }}}

" -----PLUGINS------------------------ {{{

" Plugin lightline {{{

set laststatus=2

" lightline takes care of this
set noshowmode

let g:lightline = {
	\ 'colorscheme': 'nord',
	\ 'active': {
	\   'left': [ [ 'mode', 'paste' ],
	\             [ 'buffernumber', 'gitbranch', 'readonly', 'filename', 'modified' ] ]
	\ },
	\ 'component': {
	\	'filename': '%f',
	\   'buffernumber': '%n'
	\ },
	\ 'component_function': {
	\   'gitbranch': 'fugitive#head'
	\ },
	\ }

" }}}

" Plugin vim-go ----------------------- {{{

" let g:go_fmt_command = "goimports"
" let g:go_decls_includes = "func,type"
" let g:go_list_type = "quickfix"
" " Automatic highlight same identifiers
" let g:go_auto_sameids = 1

" run :GoBuild or :GoTestCompile based on the go file
" function! s:build_go_files()
"   let l:file = expand('%')
"   if l:file =~# '^\f\+_test\.go$'
"     call go#test#Test(0, 1)
"   elseif l:file =~# '^\f\+\.go$'
"     call go#cmd#Build(0)
"   endif
" endfunction
" 
" autocmd myVimrc FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
" autocmd myVimrc FileType go nmap <leader>r <Plug>(go-run)
" autocmd myVimrc FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
" autocmd myVimrc FileType go nmap <Leader>i <Plug>(go-info)
" autocmd myVimrc FileType go nmap <Leader>d :GoDecls<CR>

" " :A replaces :GoAlternate
" autocmd myVimrc Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
" 
" " :AV opens :GoAlternate in vsplit
" autocmd myVimrc Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
" }}}

" Plugin Ultisnips --------------------- {{{

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"

" }}}

" CtrlP --------------------------------- {{{

if executable('rg')
  " Use ripgrep voor CtrlP
  let g:ctrlp_user_command = 'rg --files --color=never %s'
  let g:ctrlp_use_caching = 0
  let g:ctrlp_working_path_mode = 'ra'
  let g:ctrlp_switch_buffer = 'et'

  " Set as grep command
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" }}}

" Plugin Fzf ----------------------------------------- {{{
" :Find
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" }}}

" Plugin govim {{{

set mouse=a
set signcolumn=yes

autocmd myVimrc Filetype go nnoremap <buffer> <localleader>h : <C-u>call GOVIMHover()<CR>
autocmd myVimrc Filetype go nnoremap <buffer> <localleader>r : <C-u>call GOVIMReferences()<CR>
autocmd myVimrc Filetype go nnoremap <buffer> <localleader>n : <C-u>call GOVIMRename()<CR>

autocmd myVimrc FileType go nnoremap <buffer> <localleader>b :cexpr system('go build -o /tmp/gobuild.tmp')<cr>:cw<cr>
autocmd myVimrc FileType go nnoremap <buffer> <localleader>l :cexpr system('golangci-lint run')<cr>:cw<cr>

" }}}

" }}}
