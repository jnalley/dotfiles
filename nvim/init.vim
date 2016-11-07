" vim:ft=vim:ts=2:sw=2:et:fdm=marker

" Start vim using:
"
" vim -u ~/.myvim/vimrc
"
" or:
"
" export VIMINIT='source ~/.myvim/vimrc'

" initialization {{{

" set leader to SPACE
let mapleader=' '

" disable netrw (use dirvish instead)
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

if has('vim_starting')
  let $MYVIMRC = resolve(expand('<sfile>'))
  let s:vimdir = fnamemodify($MYVIMRC, ':p:h')
  let s:tempdir = s:vimdir . '/tmp'
  let &directory = s:tempdir . '//'
  let &viewdir = s:tempdir . '/view'
  let &undodir = s:tempdir . '/undo'
  if !has('nvim')
    let &runtimepath = printf('%s,%s,%s/after', s:vimdir, &runtimepath, s:vimdir)
    if ! isdirectory(&g:undodir) | call mkdir(&g:undodir, 'p', 0700) | endif
    if ! isdirectory(&g:undodir) | call mkdir(&g:undodir, 'p', 0700) | endif
  endif
  let s:viminfo = has('nvim') ? 'main.shada' : 'viminfo'
  let &viminfo = "!,<800,'10,/50,:100,h,f0,n" . s:tempdir . '/' . s:viminfo
  "               | |    |   |   |    | |  + path to viminfo file
  "               | |    |   |   |    | + file marks 0-9,A-Z 0=NOT stored
  "               | |    |   |   |    + disable 'hlsearch' loading viminfo
  "               | |    |   |   + command-line history saved
  "               | |    |   + search history saved
  "               | |    + files marks saved
  "               | + lines saved each register (old name for <, vi6.2)
  "               + don't preserve the buffer list
endif
" }}}

" settings {{{
set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set colorcolumn=80
set completeopt=menu
set diffopt=vertical
set fillchars+=vert:│,fold:‒
set foldenable
set foldmethod=marker
set grepformat=%f:%l:%c:%m
set grepprg=ag\ --vimgrep\ $*
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
set shortmess+=I
set showbreak=↪
set showcmd
set showmatch
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
set wildmenu
set wildmode=list:longest,full
set winminheight=0

set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
" }}}

" plugins {{{
if has('vim_starting')
  let s:plugins = s:vimdir . '/plugins'
  let s:vimplug = s:vimdir . '/autoload/plug.vim'
  let s:vimplug_url = 'https://raw.github.com/junegunn/vim-plug/master/plug.vim'

  " install vim-plug
  if ! filereadable(s:vimplug)
    execute 'silent !curl -fLo' . s:vimplug . ' --create-dirs ' . s:vimplug_url
    autocmd VimEnter * PlugInstall | source $MYVIMRC
  endif

  " combine update+upgrade
  command! PU PlugUpdate | PlugUpgrade

  call plug#begin(s:plugins)

  Plug 'junegunn/gv.vim'
  Plug 'justinmk/vim-dirvish'
  Plug 'kassio/neoterm'
  Plug 'morhetz/gruvbox'
  Plug 'nelstrom/vim-visual-star-search'
  Plug 'sh.vim', { 'for': 'sh' }
  Plug 'sheerun/vim-polyglot'
  Plug 'tpope/vim-characterize'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'

  call plug#end()
endif
" }}}

" terminal {{{
function! TNremap(...)
  if a:0 != 2 | return | endif
  execute printf('nnoremap %s %s', a:1, a:2)
  if ! has('nvim') | return | endif
  if a:1 == '<C-L>' | return | endif " preserve screen clearing
  execute printf('tnoremap %s <C-\><C-N>%s', a:1, a:2)
endfunction

call TNremap('<C-A>c', ':terminal<cr>')
call TNremap('<C-A>"', ':Buffers<cr>')
call TNremap('<C-A>p', ':bprevious<cr>')
call TNremap('<C-A>n', ':bnext<cr>')
call TNremap('<C-H>', '<C-W><C-H>')
call TNremap('<C-J>', '<C-W><C-J>')
call TNremap('<C-K>', '<C-W><C-K>')
call TNremap('<C-L>', '<C-W><C-L>')

function! CloseAllBuffersButCurrent()
  let l:curr = bufnr("%")
  let l:last = bufnr("$")

  if l:curr > 1 | silent! execute "1,".(l:curr-1)."bd" | endif
  if l:curr < l:last | silent! execute (l:curr+1).",".l:last."bd" | endif
endfunction

nnoremap <silent> <C-W>D :call CloseAllBuffersButCurrent()<CR>
" }}}

" trailing whitespace {{{
function! RemoveTrailingSpace(...)
  let l:view = winsaveview()
  if a:0 > 0
    call cursor(1, 1)
    let l:result = search('\s\+$', 'c')
    call winrestview(l:view)
    if l:result == 0 | return | endif
    if confirm("Remove trailing spaces?", "&Yes\n&No") != 1 | return | endif
  endif
  %s/\s\+$//e
  call winrestview(l:view)
endfunction

" Remove trailing whitespaces when saving
augroup TrailingWhitespace
  autocmd!
  autocmd BufWritePre * :set cmdheight=3
        \ | :call RemoveTrailingSpace('prompt')
        \ | :set cmdheight=1
augroup END

nnoremap <silent> <leader>S :call RemoveTrailingSpace()<CR>
" }}}

" autocommands {{{
augroup MyAutoCommands
  autocmd!
  " Update colorscheme with customizations
  autocmd ColorScheme * call CustomColors()
  " Automatically open quick fix window
  autocmd QuickFixCmdPost *grep* cwindow
  " Open help in vertical split
  autocmd FileType help wincmd H
  " Switch to insert mode when entering a terminal buffer
  autocmd BufEnter * if &buftype ==# 'terminal' | :startinsert | endif
  " Enable :Gstatus and friends.
  autocmd FileType dirvish call fugitive#detect(@%)
  " Map CTRL-R to reload the Dirvish buffer.
  autocmd FileType dirvish nnoremap <buffer> <C-R> :<C-U>Dirvish %<CR>
  " Help lookup in vimrc
  autocmd FileType vim setlocal keywordprg=:help
  autocmd FileType git setlocal nofoldenable
  " Reload vimrc
  autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
augroup END
" }}}

" mappings {{{

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

map <leader><leader> :b#<CR>
" }}}

" colors {{{
function! CustomColors()
  " change highlight for line numbers
  highlight LineNr
        \ ctermfg=24 ctermbg=16
        \ guifg=#005f87 guibg=#000000
  highlight CursorLineNr
        \ ctermfg=208 ctermbg=16
        \ guifg=#ff8700 guibg=#000000
  " change search highlight
  highlight Search
        \ ctermfg=51 guifg=#00ffff
  highlight IncSearch
        \ ctermfg=14 ctermbg=20 cterm=underline
        \ guifg=#00ffff guibg=#0000df gui=underline
  " change match color
  highlight MatchParen
        \ ctermfg=red ctermbg=NONE
        \ guifg=red guibg=NONE
  " misspellings in red
  highlight SpellBad
        \ ctermfg=red guifg=red
  " indicate column 80
  highlight ColorColumn
        \ ctermbg=235 guibg=#242424
  " disable background (same as terminal)
  highlight Normal
        \ ctermfg=NONE ctermbg=NONE
        \ guifg=NONE guibg=NONE
  " set operator color
  highlight Operator
        \ ctermfg=172 guifg=#df8700
  highlight Folded
        \ ctermfg=6 ctermbg=NONE
        \ guibg=NONE guifg=#008080
  highlight Error
        \ ctermfg=160 guifg=#df0000
  highlight VertSplit
        \ ctermfg=236 ctermbg=NONE
        \ guifg=#353535 guibg=NONE
  " status line colors
  highlight User1
        \ ctermfg=14 ctermbg=16
        \ guifg=#00dfff guibg=#000000
  highlight User2
        \ ctermfg=245 ctermbg=16
        \ guifg=#8a8a8a guibg=#000000
  highlight User3
        \ ctermfg=10 ctermbg=16
        \ guifg=#00ff00 guibg=#000000
endfunction

let g:gruvbox_contrast_dark='hard'

if has('nvim')
  " 24-bit color
  set termguicolors

  " neovim terminal colors
  let g:terminal_color_0 = "#282828"
  let g:terminal_color_8 = "#928374"

  " neurtral_red + bright_red
  let g:terminal_color_1 = "#cc241d"
  let g:terminal_color_9 = "#fb4934"

  " neutral_green + bright_green
  let g:terminal_color_2 = "#98971a"
  let g:terminal_color_10 = "#b8bb26"

  " neutral_yellow + bright_yellow
  let g:terminal_color_3 = "#d79921"
  let g:terminal_color_11 = "#fabd2f"

  " neutral_blue + bright_blue
  let g:terminal_color_4 = "#458588"
  let g:terminal_color_12 = "#83a598"

  " neutral_purple + bright_purple
  let g:terminal_color_5 = "#b16286"
  let g:terminal_color_13 = "#d3869b"

  " neutral_aqua + faded_aqua
  let g:terminal_color_6 = "#689d6a"
  let g:terminal_color_14 = "#8ec07c"

  " light4 + light1
  let g:terminal_color_7 = "#a89984"
  let g:terminal_color_15 = "#ebdbb2"
endif

if has('vim_starting')
  try
    colorscheme gruvbox
  catch
    colorscheme default
  endtry
endif
" }}}

" git {{{
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gv :GV<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gs :Gstatus<CR>
" }}}

" sh.vim {{{
let g:sh_indent_case_labels = 1
let g:sh_fold_enabled = 7
let g:is_bash = 1
" }}}

" neoterm {{{
let g:neoterm_position = 'horizontal'
nnoremap <silent> <f10> :TREPLSendFile<cr>
nnoremap <silent> <f9> :TREPLSendLine<cr>
vnoremap <silent> <f9> :TREPLSendSelection<cr>
" }}}

" statusline {{{
function! FugitiveStatusLine()
  let l:branch = ''
  if exists("fugitive#head")
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
      \ }

set statusline=
set statusline+=%1*%-9{g:mode_map[mode()]}%=%2*%-4m%<%f
set statusline+=%#CursorLineNr#%{FugitiveStatusLine()}%=%3*%r
set statusline+=[%{&fenc==''?&enc:&fenc}][%{&ff}]%y%1*%7p%%
set statusline+=%#CursorLineNr#%11(%l/%L%)%5(%1*%c%)
" }}}
