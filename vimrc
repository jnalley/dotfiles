" Author:  Jon Nalley

set nocompatible
filetype off
let $MYVIMRC = resolve($MYVIMRC) " resolve .vimrc symlink

" Plugins {
let vundlepath=expand('~/.vim/bundle/vundle')
if isdirectory(vundlepath)
  let &runtimepath.=','.vundlepath
  call vundle#begin()

  Plugin 'gmarik/vundle'

  " Enhancements
  Plugin 'bling/vim-airline'
  Plugin 'Shougo/vimproc'
  Plugin 'Shougo/unite-outline'
  Plugin 'nelstrom/vim-visual-star-search'
  Plugin 'Raimondi/delimitMate'
  Plugin 'Shougo/unite.vim'
  Plugin 'sudo.vim'
  Plugin 'tpope/vim-characterize'
  Plugin 'tpope/vim-repeat'
  Plugin 'tpope/vim-surround'
  Plugin 'tpope/vim-unimpaired'
  Plugin 'haya14busa/incsearch.vim'
  Plugin 'Valloric/YouCompleteMe'

  " Syntax
  Plugin 'sh.vim'
  Plugin 'sheerun/vim-polyglot'
  Plugin 'tpope/vim-endwise'

  " Lint
  Plugin 'scrooloose/syntastic'

  " Python
  Plugin 'tmhedberg/SimpylFold'

  " Javascript
  Plugin 'pangloss/vim-javascript'

  " Go
  Plugin 'fatih/vim-go'

  " Ruby
  Plugin 'vim-ruby/vim-ruby'
  Plugin 'tpope/vim-rails'

  " Colorschemes
  Plugin 'chriskempson/base16-vim'

  " Version control
  Plugin 'gregsexton/gitv'
  Plugin 'tpope/vim-fugitive'
  Plugin 'kablamo/vim-git-log'

  call vundle#end()

  " Unite {
  let g:unite_prompt='>>> '
  let g:unite_source_history_yank_enable = 1
  let g:unite_data_directory = expand('~/.vim/tmp/unite')
  call unite#filters#matcher_default#use(['matcher_fuzzy'])
  call unite#filters#sorter_default#use(['sorter_rank'])

  " split vertically
  call unite#custom#profile('default', 'context', {
        \   'vertical' : 1,
        \   'start_insert' : 1,
        \   'direction' : 'botright'
        \ })

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

  " fugitive {
  nnoremap <Leader>gl :exe "silent Glog <Bar> Unite -no-quit
        \ quickfix"<CR>:redraw!<CR>
  " }

  " delimitMate {
  let g:delimitMate_matchpairs = "(:),[:],{:}"
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
  " }

  " sh.vim {
  let g:sh_indent_case_labels = 1
  " }

  " Syntastic {
  let g:syntastic_disabled_filetypes = ['rst']
  " }
else
  echohl WarningMsg | echo "Missing Vundle!" | echohl None
endif
" }

" Colorscheme {
filetype plugin indent on
try
  if &term !~ '.*-256color$' || &t_Co != 256
    throw "Not enough colors!"
  endif
  if $TERM_PROGRAM == "Apple_Terminal"
    throw "Get a better Terminal!"
  endif
  set background=dark
  colorscheme base16-atelierforest
catch
  colorscheme desert
endtry
syntax on
" highlight Search ctermfg=123 ctermbg=20
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
" Save view (state) (folds, cursor, etc)
autocmd BufWinLeave *.* silent! mkview
" Load view (state) (folds, cursor, etc)
autocmd BufWinEnter *.* silent! loadview
" Store .swp files here instead of working directory
set directory=~/.vim/tmp//
" Directory where view files are stored
set viewdir=~/.vim/tmp/view
if !isdirectory(&g:viewdir)
  call mkdir(&g:viewdir, "p", 0700)
endif
" Open help in vertical split
autocmd FileType help wincmd H
" Delete comment character when joining commented lines
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j
endif
" Remove trailing whitespaces and ^M chars
autocmd FileType c,cpp,java,javascript,json,php,python,ruby,slim,vim,xml,yml
      \ autocmd BufWritePre <buffer> :call
      \   setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
autocmd FileType ruby,slim,yml
      \ setl ts=2 sw=2 sts=2 et
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
set visualbell t_vb=
set nonumber                    " No line numbers by default
set norelativenumber            " No relative line numbers by default
set noshowmode                  " 'airline' shows the mode
set nostartofline               " Try to preserve cursor column
set notimeout
set nowrap                      " Do not wrap long lines
set numberwidth=3               " Use only 2 columns while possible
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
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap to
set wildignore+=*.egg-info/**
set wildignore+=*.ko,*.mod.c,*.order,modules.builtin
set wildignore+=*.o,*.obj,.git,*.pyc
set wildignore+=eggs/**
set wildmenu
set wildmode=list:longest,full
set winminheight=0

" Color test: Save this file, then enter ':so %'
" Then enter one of following commands:
"   :VimColorTest    "(for console/terminal Vim)
function! VimColorTest(outfile, fgend, bgend)
  let result = []
  for fg in range(a:fgend)
    for bg in range(a:bgend)
      let kw = printf('%-7s', printf('c_%d_%d', fg, bg))
      let h = printf('hi %s ctermfg=%d ctermbg=%d', kw, fg, bg)
      let s = printf('syn keyword %s %s', kw, kw)
      call add(result, printf('%-32s | %s', h, s))
    endfor
  endfor
  call writefile(result, a:outfile)
  execute 'edit '.a:outfile
  source %
endfunction
" Increase numbers in next line to see more colors.
command! VimColorTest call VimColorTest('vim-color-test.tmp', 9, 64)

" vim: set fmr={,} fdl=0 fdm=marker ft=vim:ts=2:sw=2:noet:nowrap
