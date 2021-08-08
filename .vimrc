" Parent group for all autocommands
" this will remove all autocmd myVimrcs om resourcing .vimrc
augroup myVimrc
	autocmd!
augroup END

" Vim-Plug -----------------------------------------------

if empty(glob('/home/jerry/.vim/autoload/plug.vim'))
  silent !curl -fLo /home/jerry/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('/home/jerry/.vim/plugged')

Plug 'vimwiki/vimwiki'
Plug 'govim/govim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf.vim', { 'do': { -> fzf#install() } }
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'SirVer/ultisnips'
Plug 'arzg/vim-substrata'
Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'arcticicestudio/nord-vim'
Plug 'cocopon/iceberg.vim'
Plug 'rust-lang/rust.vim'
Plug 'elixir-editors/vim-elixir'
Plug 'ziglang/zig.vim'

" Initialize plugin system
call plug#end()


" General settings {{{

" 'q  : q, number of edited file remembered
" <m  : m, number of lines saved for each register
" :p  : p, number of  history cmd lines remembered
" %   : saves and restore the buffer list
" n...: fully qualified path to the viminfo files (note that this is a literal "n")
set viminfo='20,<100,:100,%,n/home/jerry/.vim/.viminfo

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set shell=/usr/bin/bash
set autowrite

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Syntax highlighting
filetype plugin indent on
syntax on

" colorscheme
colorscheme nord

let g:deepspace_italics=1

if &diff
	colorscheme nord
endif

set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set background=dark

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

" Keep the cursur in the middle
set scrolloff=999

set number relativenumber

set nobackup
set nowritebackup

" gotags tagfile.
" set tags=./.tags;

" Tweaks for filebrowsing with netrw
let g:netrw_banner=0        "Disable annoying banner
let g:netrw_liststyle=3     "Tree view
let g:netrw_browse_split=4  "Open in prior window

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

" General Key Mappings {{{

let mapleader = "\<space>"
let maplocalleader = "\\"

" Remap the ex-mode key.
nnoremap ; :
xnoremap ; :

" clear search highlightning.
nnoremap <silent> <leader><space> :nohlsearch<CR>

" remap window commands with 's'(never used s anyway).
nnoremap s <C-W>

" Wayland Copy/Paste
xnoremap "+y y:call system("wl-copy", @")<cr>
nnoremap <silent> "+p :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<cr>p
nnoremap <silent> "*p :let @"=substitute(system("wl-paste --no-newline --primary"), '<C-v><C-m>', '', 'g')<cr>p

" Copy/Paste to the system clipboard
" vnoremap <leader>y "+y
" nnoremap <leader>p "+p

" Presentation.
nnoremap <leader>F :.!toilet -w 200 -f standard<CR>
nnoremap <leader>f :.!toilet -w 200 -f small<CR>
nnoremap <leader>B :.!toilet -f term -F border<CR>

" next/previous slide
noremap <Left> :silent bp<CR> :redraw!<CR>
noremap <Right> :silent bn<CR> :redraw!<CR>

" clear distractions on screen.
nnoremap <F2> :setlocal number! relativenumber! hidden!<CR>

" create a new session.
nnoremap <leader>m :call MakeSession()<CR>


" }}}

" Commands {{{

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Creates a session
function! MakeSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  if (filewritable(b:sessiondir) != 2)
    exe 'silent !mkdir -p ' b:sessiondir
    redraw!
  endif
  let b:sessionfile = b:sessiondir . '/session.vim'
  exe "mksession! " . b:sessionfile
endfunction

" Updates a session, BUT ONLY IF IT ALREADY EXISTS
function! UpdateSession()
  " let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  " let b:sessionfile = b:sessiondir . "/session.vim"
  " if (filereadable(b:sessionfile))
	" exe "mksession! " . b:sessionfile
	" echo "updating session"
  " endif
  if v:this_session != ""
	  echo "updating session"
	  exe 'mksession! ' . v:this_session
  endif
endfunction

" Loads a session if it exists
function! LoadSession()
  if argc() == 0
    let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
    let b:sessionfile = b:sessiondir . "/session.vim"
    if (filereadable(b:sessionfile))
      exe 'source ' b:sessionfile
    else
      echo "No session loaded."
    endif
  else
    let b:sessionfile = ""
    let b:sessiondir = ""
  endif
endfunction


" }}}

" Filetype Settings ---------------------- {{{

autocmd myVimrc VimEnter * nested :call LoadSession()
autocmd myVimrc VimLeave * :call UpdateSession()

autocmd myVimrc FileType vim setlocal foldmethod=marker
autocmd myVimrc FileType vim setlocal foldlevelstart=0

autocmd myVimrc FileType sh setlocal foldmethod=marker
autocmd myVimrc FileType sh setlocal foldlevelstart=0

autocmd myVimrc FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd myVimrc FileType c setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd myVimrc FileType cpp setlocal shiftwidth=2 tabstop=2

" force markdown filetype on .md
autocmd myVimrc BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

autocmd myVimrc FileType c nnoremap <buffer> <C-l> :TlistToggle<CR>

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

" Plugin Ultisnips --------------------- {{{

let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<C-b>"
let g:UltiSnipsJumpBackwardTrigger="<C-z>"
let g:UltiSnipsEditSplit="vertical"

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

" [:Tags] command.
let g:fzf_tags_command = 'ctags -R'

nnoremap <leader>b :Buffers<CR>
nnoremap <leader>f :Files<CR>

" tags in the current buffer, no creation of tags file.
nnoremap <leader>t :BTags<CR>

" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" }}}

" Plugin govim {{{

" Suggestion: By default, govim populates the quickfix window with diagnostics
" reported by gopls after a period of inactivity, the time period being
" defined by updatetime (help updatetime). Here we suggest a short updatetime
" time in order that govim/Vim are more responsive/IDE-like
set updatetime=700

set mouse=a
set signcolumn=yes

" call govim#config#Set("Staticcheck", 1)
autocmd myVimrc Filetype go call govim#config#Set("CompletionBudget", "200ms")

autocmd myVimrc Filetype go nnoremap <buffer> <localleader>h : <C-u>call GOVIMHover()<CR>
autocmd myVimrc Filetype go nnoremap <buffer> <localleader>r :<C-u>GOVIMReferences<cr>
autocmd myVimrc Filetype go nnoremap <buffer> <localleader>n :<C-u>GOVIMRename<CR>
autocmd myVimrc Filetype go nnoremap <buffer> <localleader>f :<C-u>GOVIMSuggestedFixes<CR>

autocmd myVimrc FileType go nnoremap <buffer> <localleader>l :cexpr system('golangci-lint run')<cr>:cw<cr>

" }}}

" Plugin Rust {{{
let g:rustfmt_autosave = 1
" }}}

" }}}
