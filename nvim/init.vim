" vim:ft=vim:ts=2:sw=2:et:fdm=marker

" Start vim using:
"
" vim -u ~/.myvim/vimrc
"
" or:
"
" export VIMINIT='source ~/.myvim/vimrc'

" initialization {{{
if has('vim_starting')
  " set leader to SPACE
  let mapleader=' '

  " disable netrw (use dirvish instead)
  let g:loaded_netrw = 1
  let g:loaded_netrwPlugin = 1

  let $MYVIMRC = resolve(expand('<sfile>'))
  let s:vimdir = fnamemodify($MYVIMRC, ':p:h')
  let s:tempdir = s:vimdir . '/tmp'
  let &directory = s:tempdir . '//'
  let &viewdir = s:tempdir . '/view'
  let &undodir = s:tempdir . '/undo'
  if ! has('nvim')
    let &runtimepath = printf('%s,%s,%s/after', s:vimdir, &runtimepath, s:vimdir)
    if ! isdirectory(&g:undodir) | call mkdir(&g:undodir, 'p', 0700) | endif
  endif
  let s:viminfo = has('nvim') ? 'main.shada' : 'viminfo'
  let &viminfo = "!,<800,'10,/50,:100,h,f0,n" . s:tempdir . '/' . s:viminfo
                 "| |    |   |   |    | |  + path to viminfo file
                 "| |    |   |   |    | + file marks 0-9,A-Z 0=NOT stored
                 "| |    |   |   |    + disable 'hlsearch' on start
                 "| |    |   |   + command-line history saved
                 "| |    |   + search history saved
                 "| |    + files marks saved
                 "| + lines saved each register (old name for <, vi6.2)
                 "+ don't preserve the buffer list
endif
" }}}

" settings {{{
set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set colorcolumn=80
set completeopt=menuone,noinsert,noselect
set diffopt=vertical
set fillchars+=vert:│,fold:‒
set foldenable
set foldmethod=marker
set hidden
set history=500
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set list
set listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:⌴,trail:•
set matchpairs+=<:>
set mouse=
set noerrorbells visualbell
set nojoinspaces
set nonumber
set noshowmode
set nostartofline
set nowrap
set numberwidth=5
set shortmess+=Ic
set showbreak=↪
set showcmd
set noshowmatch
set showtabline=1
set smartcase
set splitbelow
set splitright
set synmaxcol=200
set ttimeout
set ttimeoutlen=-1
set virtualedit=block
set whichwrap=b,s,h,l,<,>,[,]
set wildignore+=*.gem
set wildignore+=*.o,*.obj,*.a
set wildignore+=*.pyc
set wildignore+=*/.git/*,*/.hg/*
set wildignore+=*~,*.bak
set wildchar=<Tab>
set wildmenu
set wildmode=longest,full
set winminheight=0

" grep {{{
if executable('rg')
  set grepprg=rg\ --vimgrep\ $*
  set grepformat=%f:%l:%c:%m
elseif executable('ag')
  set grepprg=ag\ --vimgrep\ $*
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
" }}}

" tabs/spaces {{{
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
" }}}

" }}}

" plugins {{{
call plug#begin(s:vimdir . '/plugged')

Plug 'christoomey/vim-tmux-navigator'
Plug 'guns/xterm-color-table.vim', { 'for': 'vim' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin --no-update-rc' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim'
Plug 'justinmk/vim-dirvish'
Plug 'lifepillar/vim-mucomplete'
Plug 'morhetz/gruvbox'
Plug 'nelstrom/vim-visual-star-search'
Plug 'sheerun/vim-polyglot'
Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-scripts/sh.vim', { 'for': 'sh' }
Plug 'w0rp/ale'

call plug#end()
" }}}

" helper functions {{{
function! CloseAllBuffersButCurrent()
  let l:curr = bufnr("%")
  let l:last = bufnr("$")

  if l:curr > 1 | silent! execute "only|1,".(l:curr-1)."bd" | endif
  if l:curr < l:last | silent! execute (l:curr+1).",".l:last."bd" | endif
endfunction

nnoremap <silent> <C-W>D :call CloseAllBuffersButCurrent()<CR>

function! DetectTrailingSpace()
  if !&modifiable
    return 0
  endif
  return search('\s\+$', 'nw')
endfunction

function! RemoveTrailingSpace()
  let l:view = winsaveview()
  %s/\s\+$//e
  call winrestview(l:view)
endfunction

nnoremap <silent> <leader>S :call RemoveTrailingSpace()<CR>
" }}}

" autocommands {{{
augroup VimRc
  autocmd!
  " Automatically open quick fix window
  autocmd QuickFixCmdPost *grep* cwindow
  " Open help in vertical split
  autocmd FileType help wincmd H
  " Switch to insert mode when entering a terminal buffer
  autocmd BufEnter * if &buftype ==# 'terminal' | :startinsert | endif
  " Enable :Gstatus and friends.
  autocmd FileType dirvish call fugitive#detect(@%)
  " Help lookup in vimrc
  autocmd FileType vim setlocal keywordprg=:help
  " Prevent folding in git
  autocmd FileType git setlocal nofoldenable
  " Reload vimrc
  autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
augroup END
" }}}

" mappings {{{

" list buffers (fzf)
nnoremap <leader><tab> :Buffers<CR>

" search help (fzf)
nnoremap <leader>? :Helptags<CR>

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
nnoremap <leader>v :e! $MYVIMRC<cr>

" auto indent pasted text
nnoremap p gp=`]
nnoremap P gP=`]

" previous buffer
nnoremap <leader><leader> :b#<CR>
" }}}

" colorscheme {{{
let g:gruvbox_contrast_dark='hard'

try
  colorscheme gruvbox
catch
  colorscheme default
endtry
" }}}

" git {{{
autocmd VimRc BufReadPost fugitive://* set bufhidden=delete
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gl :silent Glog<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gr :Gremove<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gw :Gwrite<CR>
" }}}

" ale {{{
let g:ale_lint_on_text_changed = 'never'
let g:ale_open_list = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_sign_error = "✗"
let g:ale_sign_warning = "⚠"
" }}}

" {{{ mucomplete
let g:mucomplete#enable_auto_at_startup = 1

if exists("g:loaded_mucomplete")
  inoremap <expr> <c-e> mucomplete#popup_exit("\<c-e>")
  inoremap <expr> <c-y> mucomplete#popup_exit("\<c-y>")
  inoremap <expr>  <cr> mucomplete#popup_exit("\<cr>")
endif
" }}}

" fzf {{{
if has('nvim')
  let g:fzf_layout = { 'window': 'enew' }
endif

" Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Use ripgrep for vimgrep
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
" }}}

" dirvish {{{
let g:dirvish_mode = ':sort r /[^\/]$/'
" }}}

" sh.vim {{{
let g:sh_indent_case_labels = 1
let g:sh_fold_enabled = 7
let g:is_bash = 1
" }}}

" statusline {{{
function! FugitiveStatusLine()
  let l:branch = ''
  if exists("*fugitive#head")
    let l:branch = fugitive#head()
  endif
  return branch !=# '' ? ' {'.branch.'}' : ''
endfunction

let g:mode_map={
      \ '__' : '------',
      \ 'n'  : 'NORMAL',
      \ 'i'  : 'INSERT',
      \ 'R'  : 'REPLACE',
      \ 'v'  : 'VISUAL',
      \ 'V'  : 'V-LINE',
      \ 'c'  : 'COMMAND',
      \ '' : 'V-BLOCK',
      \ 's'  : 'SELECT',
      \ 'S'  : 'S-LINE',
      \ '' : 'S-BLOCK',
      \ 't'  : 'TERMINAL',
      \ 'r?'  : 'CONFIRM',
      \ }

setlocal statusline=
setlocal statusline+=%1*%{g:mode_map[mode()]}
setlocal statusline+=%=%3*%-4m%2*%<%f%4*%{FugitiveStatusLine()}
setlocal statusline+=%=%5*%{DetectTrailingSpace()==0?'':'[S]'}
setlocal statusline+=%1*%{&paste?'[paste]':''}
setlocal statusline+=%3*%r[%{&fenc==''?&enc:&fenc}][%{&ff}]%y
setlocal statusline+=%1*%7p%%%3*%4*%11(%l/%L%)%5(%1*%c%)
" }}}
