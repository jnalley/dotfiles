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
  let s:notedir = s:vimdir . '/doc'
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
set completeopt-=preview
set completeopt+=menuone,noinsert,noselect
set diffopt=vertical
set fillchars+=vert:│,fold:‒
set foldenable
set foldmethod=marker
set hidden
set history=500
set hlsearch
set ignorecase
set incsearch
set infercase
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
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin --no-update-rc' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim'
Plug 'justinmk/vim-dirvish'
Plug 'lifepillar/vim-mucomplete'
Plug 'morhetz/gruvbox'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'guns/xterm-color-table.vim'
Plug 'vim-scripts/sh.vim', { 'for': 'sh' }
Plug 'w0rp/ale'

call plug#end()
" }}}

" helper functions {{{
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
" }}}

" autocommands {{{
augroup VimRc
  autocmd!
  " Automatically open quick fix window
  autocmd QuickFixCmdPost *grep* cwindow
  " Open help in vertical split
  autocmd FileType help wincmd H
  " Switch to insert mode when entering a terminal buffer
  " autocmd BufEnter * if &buftype ==# 'terminal' | :startinsert | endif
  " Enable :Gstatus and friends.
  autocmd FileType dirvish call fugitive#detect(@%)
  " Help lookup in vimrc
  autocmd FileType vim setlocal keywordprg=:help
  " Prevent folding in git
  autocmd FileType git setlocal nofoldenable
  " Reload vimrc
  autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
  " Update tags for notes
  exec "autocmd bufwritepost " . s:notedir . "/* " . ":helptags " . s:notedir
augroup END
" }}}

" mappings {{{

" choose buffer
nnoremap <leader><tab> :buffers<CR>:buffer<Space>

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

" close window
map <C-x> <C-w>c

" remove trailing spaces
nnoremap <silent> <leader>S :call RemoveTrailingSpace()<CR>

" escape terminals
tnoremap <C-H> <C-\><C-N><C-W><C-H>
tnoremap <C-J> <C-\><C-N><C-W><C-J>
tnoremap <C-K> <C-\><C-N><C-W><C-K>
tnoremap <C-L> <C-\><C-N><C-W><C-L>

tnoremap <leader><esc> <C-\><C-N>
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
let g:ale_set_signs = 0
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_delay = 0
let g:ale_linters = {'java': []} " disable for java to prevent popup in osx
let g:ale_fixers = {'python': ['autopep8', 'black', 'isort'], 'sh': ['shfmt'], 'javascript': ['prettier']}
let g:ale_python_black_options = '--line-length 79'
let g:ale_sh_shfmt_options = '-i 2 -ci'
" navigation
nmap <silent> <leader>ee <Plug>(ale_lint)
nmap <silent> <leader>ff <Plug>(ale_fix)
" }}}

" {{{ python
if filereadable($PYTHON2)
  let g:python_host_prog = $PYTHON2
endif

if filereadable($PYTHON3)
  let g:python3_host_prog = $PYTHON3
endif

command! -nargs=? Ipython silent! vnew | :call termopen("ipython --no-autoindent -i -- " . expand(<q-args>)) | wincmd <c-p>
command! -nargs=+ Pydoc silent! vnew | te PAGER=cat pydoc <q-args>

autocmd VimRc FileType python setlocal keywordprg=:Pydoc
" }}}

" {{{ mucomplete
let g:mucomplete#enable_auto_at_startup = 1
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

" grep for word at cursor
nnoremap <silent> <c-f> :Rg <C-R><C-W><CR>
" }}}

" dirvish {{{
let g:dirvish_mode = ':sort r /[^\/]$/|silent keeppatterns g/\.pyc$/d _'
let g:dirvish_relative_paths = 1
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

set statusline=
set statusline+=%1*%{g:mode_map[mode()]}
set statusline+=%=%3*%-4m%2*%<%f%4*%{FugitiveStatusLine()}
set statusline+=%=%5*%{DetectTrailingSpace()==0?'':'[S]'}
set statusline+=%1*%{&paste?'[paste]':''}
set statusline+=%3*%r[%{&fenc==''?&enc:&fenc}][%{&ff}]%y
set statusline+=%1*%7p%%%3*%4*%11(%l/%L%)%5(%1*%c%)
" }}}
