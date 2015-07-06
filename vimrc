" Author:  Jon Nalley

set nocompatible
filetype off
let $MYVIMRC = resolve($MYVIMRC) " resolve .vimrc symlink

" Plugins {
let s:plugins = join([fnamemodify($MYVIMRC,':h'),'vim','plugins'],'/')
if filereadable(join([fnamemodify(s:plugins,':h'),'autoload','plug.vim'],'/'))
  call plug#begin(s:plugins)

  Plug 'ConradIrwin/vim-bracketed-paste'
  Plug 'Shougo/unite-outline'
  Plug 'Shougo/unite.vim'
  Plug 'Shougo/vimproc.vim', { 'do': 'make' }
  Plug 'Valloric/YouCompleteMe', { 'do': './install.sh --clang-completer' }
  Plug 'bling/vim-airline'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'gregsexton/gitv'
  Plug 'haya14busa/incsearch.vim'
  Plug 'jiangmiao/auto-pairs'
  Plug 'mbbill/undotree'
  Plug 'morhetz/gruvbox'
  Plug 'nelstrom/vim-visual-star-search'
  Plug 'scrooloose/syntastic'
  Plug 'sh.vim', { 'for': 'sh' }
  Plug 'sheerun/vim-polyglot'
  Plug 'sudo.vim'
  Plug 'tmhedberg/SimpylFold', { 'for': 'python' }
  Plug 'tpope/vim-characterize'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rails', { 'for': 'ruby' }
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'

  call plug#end()

  " Unite {
  let g:unite_prompt='>>> '
  let g:unite_source_history_yank_enable = 1
  let g:unite_data_directory = expand('~/.vim/tmp/unite')
  silent! call unite#filters#matcher_default#use(['matcher_fuzzy'])
  silent! call unite#filters#sorter_default#use(['sorter_rank'])

  " split vertically
  silent! call unite#custom#profile('default', 'context',
    \ {'vertical': 1, 'start_insert': 1, 'direction': 'botright'})

  nnoremap <leader>rf :<C-u>Unite -buffer-name=files file_rec/async:!<cr>
  nnoremap <leader>f  :<C-u>Unite -buffer-name=files file<cr>
  nnoremap <leader>o  :<C-u>Unite -buffer-name=outline outline<cr>
  nnoremap <leader>be :<C-u>Unite -buffer-name=buffer -no-start-insert buffer<cr>

  " Custom mappings for the unite buffer
  autocmd FileType unite call s:unite_settings()
  function! s:unite_settings()
    " Enable navigation with control-j and control-k in insert mode
    imap <buffer> <C-j> <Plug>(unite_select_next_line)
    imap <buffer> <C-k> <Plug>(unite_select_previous_line)
    nmap <buffer> <ESC> <Plug>(unite_exit)
  endfunction
  " }

  " git {
  nnoremap <leader>gb :Gblame<CR>
  nnoremap <leader>gl :Gitv<CR>
  nnoremap <leader>gd :Gdiff<CR>
  nnoremap <leader>gs :Gstatus<CR>
  let g:Gitv_WipeAllOnClose = 1
  let g:Gitv_OpenPreviewOnLaunch = 1
  " }

  " auto-pairs {
  let g:AutoPairsFlyMode = 0
  " }

  " incsearch {
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  " }

  " Air-Line {
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline_inactive_collapse = 1
  let g:airline#extensions#syntastic#enabled = 1
  let g:airline_section_b = '%{&expandtab?"S":"T"}'
  " }

  " sh.vim {
  let g:sh_indent_case_labels = 1
  " }

  " undotree {
  let g:undotree_SetFocusWhenToggle = 1
  let g:undotree_DiffAutoOpen = 0
  let g:undotree_DiffCommand = "diff -u"
  let g:undotree_WindowLayout = 2
  nnoremap <leader>ut :UndotreeToggle<cr>
  " }

  " Syntastic {
  let g:syntastic_disabled_filetypes = ['rst']
  " }
else
  echohl WarningMsg | echo "Missing vim-plug!" | echohl None
endif
" }

" Colors {
filetype plugin indent on
set background=dark
try
  let g:gruvbox_contrast='hard'
  colorscheme gruvbox
catch
  colorscheme desert
endtry
syntax on
" change highlight for line numbers
highlight LineNr ctermbg=16 ctermfg=24
" change search highlight
highlight Search ctermfg=51 ctermbg=20
highlight IncSearch ctermfg=51 ctermbg=20 cterm=underline
" change match color
highlight MatchParen
      \ cterm=bold ctermfg=red ctermbg=NONE
" misspellings in red
highlight SpellBad ctermfg=red
" highlight long lines
highlight OverLength ctermbg=52 ctermfg=242
match OverLength /\%80v.\+/
" }

" Autocommands {
" Reload .vimrc when it's edited
augroup myvimrc
  au!
  au BufWinEnter $MYVIMRC setl ts=2 sw=2 sts=2 et
  au BufWritePost $MYVIMRC source $MYVIMRC
augroup END
" Automatically open quick fix window
autocmd QuickFixCmdPost *grep* cwindow
" Save view (state) (folds, cursor, etc)
autocmd BufWinLeave *.* silent! mkview
" Load view (state) (folds, cursor, etc)
autocmd BufWinEnter *.* silent! loadview
" Set formatoptions correctly
autocmd BufWinEnter,BufNewFile * setl formatoptions-=o formatoptions+=n,2,1,j
" Store .swp files here instead of working directory
set directory=~/.vim/tmp//
" Directory where view files are stored
set viewdir=~/.vim/tmp/view
if !isdirectory(&g:viewdir)
  call mkdir(&g:viewdir, "p", 0700)
endif
" Open help in vertical split
autocmd FileType help wincmd H
" Remove trailing whitespaces and ^M chars
autocmd FileType c,cpp,java,javascript,json,php,python,ruby,sh,slim,vim,xml,yml
      \ autocmd BufWritePre <buffer> :call
      \ setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
autocmd FileType html,ruby,slim,yml
      \ setl ts=2 sw=2 sts=2 et
autocmd FileType go
      \ set nolist
" }

" Key (re) mappings {
" Edit .vimrc
map <leader>v :e! $MYVIMRC<cr>

" Next buffer
map <leader>bn :bnext<cr>

" Previous buffer
map <leader>bp :bprevious<cr>

" Remove trailing whitespace
nnoremap <leader>S :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" Toggle 'set list'
nmap <leader>l :set list!<CR>

" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk

" Clearing highlighted search
nmap <silent> <leader><cr> :nohlsearch<cr>

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Toggle tab mode
map <leader>t :call TabToggle()<CR>

" Toggle line numbering
map <silent> <leader>nr :set relativenumber!<CR>
map <silent> <leader>nn :set number!<CR>

" Navigate splits more easily
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" }

" BASH Tweaks {
let g:sh_fold_enabled = 7   " Enable function, heredoc and if/do/for folding
let g:is_bash=1             " Use bash syntax for shell scripts by default
" }

" Spaces and Tabs {
set noexpandtab

function! TabToggle()
  if &expandtab
    " https://www.kernel.org/doc/Documentation/CodingStyle
    set tabstop=8
    set shiftwidth=8
    set softtabstop=8
    set noexpandtab
  else
    set tabstop=4
    set shiftwidth=4
    set softtabstop=4
    set expandtab
  endif
endfunction

call TabToggle()
" }

set autoindent                  " Indent at the same level of the previous line
set backspace=indent,eol,start  " Backspace for dummies
set completeopt=menu
set diffopt=vertical            " Start diff mode with vertical splits.
set foldenable                  " Auto fold code
set hidden                      " Allow buffer switching without saving
set history=200                 " Store a ton of history (default is 20)
set hlsearch                    " Highlight search terms
set ignorecase                  " Case insensitive search
set incsearch                   " Find as you type search
set laststatus=2                " Always show statusline
set lazyredraw                  " Don't redraw while executing macros.
set linespace=0                 " No extra spaces between rows
set list                        " Show 'listchars' by default
set listchars=tab:▸\ ,trail:•   " Show tab characters and trailing whitespace
set matchpairs+=<:>             " Alow < & > to be matched with %
set nocursorcolumn              " Don't highlight current line
set nocursorline                " Don't highlight current line
set noerrorbells                " Silence is golden
set nonumber                    " No line numbers by default
set norelativenumber            " No relative line numbers by default
set noshowmode                  " 'airline' shows the mode
set nostartofline               " Try to preserve cursor column
set notimeout
set nowrap                      " Do not wrap long lines
set numberwidth=5
set pastetoggle=<F12>           " Pastetoggle (sane indentation when pasting)
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set showcmd                     " Show partial commands in status line
set showmatch                   " Show matching brackets/parenthesis
set showtabline=2               " Always show tabline
set smartcase                   " Case sensitive when uc present
set splitbelow
set splitright
set synmaxcol=200               " Prevent long lines from slowing down redraws.
set tabpagemax=15               " Only show 15 tabs
set ttimeout
set ttimeoutlen=20
set ttyfast                     " Indicates a fast terminal connection.
set virtualedit=block           " Allow virtualedit in visual block mode
set visualbell t_vb=
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap to
set wildignore+=*.egg-info/**
set wildignore+=*.ko,*.mod.c,*.order,modules.builtin
set wildignore+=*.o,*.obj,.git,*.pyc
set wildignore+=eggs/**
set wildmenu
set wildmode=list:longest,full
set winminheight=0
" silver searcher
if executable('ag')
  set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
  set grepformat=%f:%l:%c:%m
endif

" vim: set fmr={,} fdl=0 fdm=marker ft=vim:ts=2:sw=2:noet:nowrap
