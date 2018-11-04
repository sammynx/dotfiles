" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set shell=/usr/bin/bash
set autowrite

let mapleader = ","

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Pathogen
execute pathogen#infect()

" Parent group for all autocommands
" this will remove all autocmd myVimrcs om resourcing .vimrc
augroup myVimrc
	autocmd!
augroup END

" statusline
set laststatus=2

" lightline takes care of this
set noshowmode

let g:lightline = {
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

" Copy/Paste to the system clipboard
vnoremap <leader>y "+y
nnoremap <leader>p "+p

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
set showcmd

set scrolloff=1

" Remap the ex-mode key.
nnoremap ; :

" For all text files set 'textwidth' to 78 characters.
autocmd myVimrc FileType text setlocal textwidth=78
autocmd myVimrc FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd myVimrc FileType c setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd myVimrc FileType cpp setlocal shiftwidth=2 tabstop=2

" vim-go

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd myVimrc FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd myVimrc FileType go nmap <leader>r  <Plug>(go-run)
autocmd myVimrc FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
autocmd myVimrc FileType go nmap <Leader>i <Plug>(go-info)
autocmd myVimrc FileType go nmap <Leader>d :GoDecls<CR>
" :A replaces :GoAlternate
autocmd myVimrc Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
" :AV opens :GoAlternate in vsplit
autocmd myVimrc Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')

let g:go_fmt_command = "goimports"
let g:go_decls_includes = "func,type"

" Automatic highlight same identifiers
" let g:go_auto_sameids = 1

" Force markdown on *.md files.
autocmd myVimrc BufNewFile,BufReadPost *.md set filetype=markdown

" Plugin markdownfmt
let g:markdownfmt_autosave = 1
let g:markdownfmt_command = 'markdownfmt'

" Buffer navigation
nnoremap gb :ls<CR>:buffer<Space>
nnoremap gB :ls<CR>:vertical rightbelow sbuffer<Space>

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Tweaks for filebrowsing with netrw
let g:netrw_banner=0        "Disable annoying banner
let g:netrw_liststyle=3     "Tree view
let g:netrw_browse_split=4  "Open in prior window

"alias for netrw open on left
command! E Lexplore

" Taglist plugin
let Tlist_Compact_Format = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select = 1

autocmd myVimrc FileType c nnoremap <C-l> :TlistToggle<CR>

if executable('rg')
  " Use ripgrep voor CtrlP
  let g:ctrlp_user_command = 'rg --files %s'
  let g:ctrlp_use_caching = 0
  let g:ctrlp_working_path_mode = 'ra'
  let g:ctrlp_switch_buffer = 'et'
  " Set as grep command
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
