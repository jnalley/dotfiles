" vim:ft=vim:ts=3:sw=2:et:fdm=marker

" Start vim using:
"
" vim -u ~/.myvim/vimrc
"
" or:
"
" export VIMINIT='source ~/.myvim/vimrc'

" initialization {{{
if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
else
  set nocompatible
  set ttyfast
endif

" disable netrw (use dirvish instead)
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

" Set leader as easily accessible for both hands
let mapleader=' '
" map <Space> <leader>

let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after',
  \ $VIM, $VIMRUNTIME, $VIM)
let $MYVIMRC = resolve(expand('<sfile>'))
let s:vimdir = fnamemodify($MYVIMRC, ':p:h')
let &runtimepath = printf('%s,%s,%s/after',
  \ s:vimdir, &runtimepath, s:vimdir)
let s:tempdir = s:vimdir . '/tmp'
let &directory = s:tempdir . '//'
let &viewdir = s:tempdir . '/view'
if ! isdirectory(&g:viewdir) | call mkdir(&g:viewdir, 'p', 0700) | endif
let &viminfo = "!,<800,'10,/50,:100,h,f0,n" . s:tempdir . '/viminfo'
"               | |    |   |   |    | |  + path to viminfo file
"               | |    |   |   |    | + file marks 0-9,A-Z 0=NOT stored
"               | |    |   |   |    + disable 'hlsearch' loading viminfo
"               | |    |   |   + command-line history saved
"               | |    |   + search history saved
"               | |    + files marks saved
"               | + lines saved each register (old name for <, vi6.2)
"               + don't preserve the buffer list
" }}}

" settings {{{
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set colorcolumn=80
set completeopt=menu
set diffopt=vertical
set foldenable
set grepprg=ag\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m
set hidden
set history=500
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set list
set listchars=tab:▸\ ,trail:•
set matchpairs+=<:>
set mouse=
set noerrorbells visualbell t_vb=
set nonumber
set norelativenumber
set noshowmode
set nostartofline
set nowrap
set numberwidth=5
set shortmess+=I
set showcmd
set showmatch
set showtabline=1
set smartcase
set splitbelow
set splitright
set synmaxcol=200
set ttimeout
set ttimeoutlen=-1
set updatetime=250
set virtualedit=block
set whichwrap=b,s,h,l,<,>,[,]
set wildignore+=*.gem
set wildignore+=*.o,*.obj,*.a
set wildignore+=*.pyc
set wildignore+=*/.git/*,*/.hg/*
set wildignore+=*~,*.bak
set wildmenu
set wildmode=list:longest,full
set winminheight=0
" }}}

" plugins {{{
let s:plugins = s:vimdir . '/plugins'
let s:vimplug = s:vimdir . '/autoload/plug.vim'
let s:vimplug_url =
  \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

" install vim-plug
if ! filereadable(s:vimplug)
  execute 'silent !curl -fLo' . s:vimplug . ' --create-dirs ' . s:vimplug_url
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" combine update+upgrade
command! PU PlugUpdate | PlugUpgrade

call plug#begin(s:plugins)

Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'Valloric/YouCompleteMe', { 'on': [], 'do': '--clang-completer --gocode-completer --tern-completer' }
Plug 'ap/vim-css-color'
Plug 'cohama/lexima.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/gv.vim'
Plug 'justinmk/vim-dirvish'
Plug 'morhetz/gruvbox'
Plug 'nelstrom/vim-visual-star-search'
Plug 'scrooloose/syntastic'
Plug 'sh.vim', { 'for': 'sh' }
Plug 'sheerun/vim-polyglot'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

call plug#end()
" }}}

" functions {{{
function! TNremap(...)
  if a:0 != 2 | return | endif
  execute printf('nnoremap %s %s', a:1, a:2)
  if ! has('nvim') | return | endif
  if a:1 == '<C-L>' | return | endif " preserve screen clearing
  execute printf('tnoremap %s <C-\><C-N>%s', a:1, a:2)
endfunction

" Quote a word consisting of letters from iskeyword.
nnoremap <silent> qw :call Quote('"')<CR>
nnoremap <silent> qs :call Quote("'")<CR>
nnoremap <silent> wq :call UnQuote()<CR>

function! Quote(quote)
  normal mz
  exe 's/\(\k*\%#\k*\)/' . a:quote . '\1' . a:quote . '/'
  normal `zl
endfunction

function! UnQuote()
  normal mz
  exe 's/["' . "'" . ']\(\k*\%#\k*\)[' . "'" . '"]/\1/'
  normal `z
endfunction
" }}}

" autocommands {{{
" save view (state) (folds, cursor, etc)
autocmd BufWinLeave *.* silent! mkview
" load view (state) (folds, cursor, etc)
autocmd BufWinEnter *.* silent! loadview
if v:version > 703
  " set formatoptions correctly
  autocmd BufWinEnter,BufNewFile * setl formatoptions-=o formatoptions+=n,2,1,j
endif
" open help in vertical split
autocmd FileType help wincmd H
" remove trailing whitespaces and ^M chars
autocmd FileType c,cpp,java,javascript,json,php,python,ruby,sh,slim,vim,xml,yml
      \ autocmd BufWritePre <buffer> :call
      \ setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
autocmd FileType go
      \ set nolist
" switch to insert mode when entering a terminal buffer
autocmd BufEnter * if &buftype ==# 'terminal' | :startinsert | endif
" defer ycm startup
" augroup load_ycm
"   autocmd!
"   autocmd InsertEnter * call plug#load('YouCompleteMe') | autocmd! load_ycm
" augroup END
autocmd VimEnter * command! Buffers
  \ call fzf#vim#buffers({'right': '25%'})
augroup my_dirvish_events
  autocmd!
  " Enable :Gstatus and friends.
  autocmd FileType dirvish call fugitive#detect(@%)

  " Map CTRL-R to reload the Dirvish buffer.
  autocmd FileType dirvish nnoremap <buffer> <C-R> :<C-U>Dirvish %<CR>
augroup END
" }}}

" colors {{{
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

" change highlight for line numbers
highlight LineNr
      \ ctermfg=24 ctermbg=16
      \ guifg=#005f87 guibg=#000000
highlight CursorLineNr
      \ ctermfg=208 ctermbg=16
      \ guifg=#ff8700  guibg=#000000
" change search highlight
highlight Search
      \ ctermfg=51 ctermbg=20
      \ guifg=#00ffff guibg=#0000d7
highlight IncSearch
      \ ctermfg=51 ctermbg=20 cterm=underline
      \ guifg=#00ffff guibg=#0000d7 gui=underline
" change match color
highlight MatchParen
      \ ctermfg=red ctermbg=NONE
      \ guifg=red guibg=NONE
" misspellings in red
highlight SpellBad
      \ ctermfg=52
      \ guifg=#5f0000
" indicate column 80
highlight ColorColumn
      \ ctermbg=233 guibg=#121212
highlight TermCursor
      \ ctermfg=40 guifg=#00d700
" disable background (same as terminal)
highlight Normal
      \ ctermbg=NONE ctermfg=NONE
      \ guifg=NONE guibg=NONE
" set operator color
highlight Operator
      \ ctermfg=172 guifg=#df8700
highlight Folded
      \ ctermfg=24 guifg=#005f87
      \ ctermbg=NONE guibg=NONE
" }}}

" lightline {{{
let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox'
" }}}

" git {{{
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gv :GV<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gs :Gstatus<CR>
" }}}

" syntastic {{{
let g:ycm_show_diagnostics_ui = 0
let g:syntastic_disabled_filetypes = ['rst']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"
let g:syntastic_style_error_symbol = "☁"
let g:syntastic_style_warning_symbol = "☂""
let g:syntastic_javascript_checkers = ['eslint']
" }}}

" sh.vim {{{
let g:sh_indent_case_labels = 1
let g:sh_fold_enabled = 7
let g:is_bash = 1
" }}}

" mappings {{{
" remove trailing whitespace
nnoremap <leader>S :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk

" clear highlighted search
noremap <silent> <cr> :nohlsearch<cr><cr>

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" select pasted text
noremap gV `[v`]

" execute default register.
nnoremap Q @q

" edit vimrc
map <leader>v :e! $MYVIMRC<cr>

" auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

call TNremap('<C-A>c', ':terminal<cr>')
call TNremap('<C-A>"', ':Buffers<cr>')
call TNremap('<C-A>p', ':bprevious<cr>')
call TNremap('<C-A>n', ':bnext<cr>')
call TNremap('<C-H>', '<C-W><C-H>')
call TNremap('<C-J>', '<C-W><C-J>')
call TNremap('<C-K>', '<C-W><C-K>')
call TNremap('<C-L>', '<C-W><C-L>')
" }}}
