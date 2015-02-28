" Description {
"   Author:  Jon Nalley
"   Updated: 2013-10-02
" }

" Environment {
    set nocompatible                " Disable VI compatibility
    set background=dark             " Dark background
    filetype off                    " Vundle enables filetype
    set rtp+=~/.vim/bundle/vundle   " Enable vundle
    call vundle#rc()
" }

" Plugins {
    " Vundle {
        Plugin 'gmarik/vundle'
    " }

    " Enhancements {
        Plugin 'bling/vim-airline'
        Plugin 'h1mesuke/unite-outline'
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
    " }

    " Programming {
        " Syntax {
            Plugin 'sh.vim'
            Plugin 'sheerun/vim-polyglot'
            Plugin 'tpope/vim-endwise'
        " }
        " Lint {
            Plugin 'scrooloose/syntastic'
        " }
        " Python {
            Plugin 'tmhedberg/SimpylFold'
        " }
        " Javascript {
            Plugin 'pangloss/vim-javascript'
        " }
        " Go {
            Plugin 'fatih/vim-go'
        "
        " Ruby {
            Plugin 'vim-ruby/vim-ruby'
            Plugin 'tpope/vim-rails'
        " }
    " }

    " Colorschemes {
        Plugin 'altercation/vim-colors-solarized'
    " }

    " Version control {
        Plugin 'gregsexton/gitv'
        Plugin 'tpope/vim-fugitive'
    " }
" }

" Functions {
    " Set indention for "normal" or "kernel" mode {
        function! EditMode(m)
            let modes = {
              \ 'normal': {
              \     'tabstop': 4,
              \     'softtabstop': 4,
              \     'shiftwidth': 4,
              \     'expandtab': 1
              \ },
              \ 'ruby': {
              \     'tabstop': 2,
              \     'softtabstop': 2,
              \     'shiftwidth': 2,
              \     'expandtab': 1
              \ },
              \ 'kernel': {
              \     'tabstop': 8,
              \     'softtabstop': 8,
              \     'shiftwidth': 8
              \ } }

            if has_key(modes, a:m)
                " indent every n columns
                let &tabstop = modes[a:m]['tabstop']
                " backspace deletes indent
                let &softtabstop = modes[a:m]['softtabstop']
                " use indents of n spaces
                let &shiftwidth = modes[a:m]['shiftwidth']

                if has_key(modes[a:m], 'expandtab')
                    set expandtab   " tabs are spaces
                else
                    set noexpandtab " tabs are tabs
                endif
            endif
        endfunction

    " }
" }

" General {
    filetype plugin indent on   " Automatically detect file types
    syntax on                   " Enable syntax highlighting
    set mouse=v                 " Enable mouse only for visual mode
    set autoread                " Auto re-load files when they are changed from the outside
    scriptencoding utf-8
    " Completion {
        set completeopt=menu
    " }
    " reload .vimrc when it's edited
    augroup vimrcs
        au!
        au bufwritepost ~/.vimrc
            \ source ~/.vimrc
    augroup END
    " reload .tmux.conf when it's edited
    autocmd bufwritepost .tmux.conf silent! :!tmux source-file ~/.tmux.conf \; display-message "  tmux config reloaded..."
    set shortmess+=filmnrxoOtT      " abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " better unix / windows compatibility
    set virtualedit=block           " Allow virtualedit in visual block mode
    set history=500                 " Store a ton of history (default is 20)
    set nospell                     " Disable spell checking
    set hidden                      " Allow buffer switching without saving
    set title                       " Set terminal title using escape codes
    set noerrorbells                " Silence is golden
    set noerrorbells visualbell t_vb=
    " Performance Tweaks {
        set ttyfast            " Indicates a fast terminal connection.
        set synmaxcol=200      " Prevent long lines from slowing down redraws.
        set lazyredraw         " Don't redraw while executing macros.
        set ttimeout
        set ttimeoutlen=20
        set notimeout
    " }
    set directory=~/.vim/tmp//                  " store .swp files here instead of working directory
    set viewdir=~/.vim/tmp/view                 " directory where view files are stored
    if !isdirectory(&g:viewdir)
        call mkdir(&g:viewdir, "p", 0700)
    endif
    autocmd BufWinLeave *.* silent! mkview      " make vim save view (state) (folds, cursor, etc)
    autocmd BufWinEnter *.* silent! loadview    " make vim load view (state) (folds, cursor, etc)
" }

" Vim UI {
    try
        colorscheme solarized
        let g:solarized_termcolors=&t_Co
    catch
        " Fallback to a builtin colorscheme
        colorscheme desert
    endtry
    " Settings for GUI version
    if has("gui_running")
        set guifont=Inconsolata-dz\ for\ Powerline:h12
        " remove scrollbar
        set guioptions-=r
        set guioptions-=R
        set guioptions-=l
        set guioptions-=L
        set transparency=8
    endif
    " Change match color
    highlight MatchParen
        \ gui=bold guifg=red guibg=NONE
        \ cterm=bold ctermfg=red ctermbg=NONE
    set tabpagemax=15               " only show 15 tabs
    set noshowmode                  " 'airline' shows the mode
    set nocursorline                " don't highlight current line
    set nocursorcolumn              " don't highlight current line
    set showtabline=2               " Always show tabline
    set laststatus=2                " Always show statusline
    set showcmd                     " show partial commands in status line
    set backspace=indent,eol,start  " backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set nostartofline               " Try to preserve cursor column
    set nonumber                    " No line numbers by default
    set norelativenumber            " No relative line numbers by default
    set numberwidth=3               " Use only 2 columns while possible
    set showmatch                   " show matching brackets/parenthesis
    set incsearch                   " find as you type search
    set hlsearch                    " highlight search terms
    set winminheight=0              " windows can be 0 line high
    set ignorecase                  " case insensitive search
    set smartcase                   " case sensitive when uc present
    set wildmenu                    " show list instead of just completing
    set wildmode=list:longest,full  " command <Tab> completion, list matches, then longest common part, then all.
    " Exclude when completing
    set wildignore+=*.o,*.obj,.git,*.pyc
    set wildignore+=eggs/**
    set wildignore+=*.egg-info/**
    set whichwrap=b,s,h,l,<,>,[,]   " backspace and cursor keys wrap to
    set scrolljump=5                " lines to scroll when cursor leaves screen
    set scrolloff=3                 " minimum lines to keep above and below cursor
    set foldenable                  " auto fold code
    set list                        " show 'listchars' by default
    set listchars=tab:▸\ ,trail:•   " Show tab characters and trailing whitespace
" }

" Formatting {
    set nowrap                      " do not wrap long lines
    set autoindent                  " indent at the same level of the previous line
    call EditMode("normal")         " 'normal' editmode (spaces and tabstop=4)
    set matchpairs+=<:>             " alow < & > to be matched with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    set splitbelow
    set splitright
    hi SpellBad ctermfg=red
    " Highlight long lines
    highlight OverLength ctermbg=52 ctermfg=242 guibg=#592929
    match OverLength /\%80v.\+/
    " Remove trailing whitespaces and ^M chars
    autocmd FileType c,cpp,java,javascript,json,php,python,ruby,slim,vim,xml,yml
        \ autocmd BufWritePre <buffer> :call
        \   setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
    autocmd FileType ruby,slim,yml
        \ call EditMode("ruby")
" }

" BASH {
    let g:sh_fold_enabled = 7       " enable function, heredoc and if/do/for folding
    let g:is_bash=1                 " use bash syntax for shell scripts by default
" }

" Key (re) Mappings {
    " Edit .vimrc
    map <leader>v :e! ~/.vimrc<cr>

    " open/close the quickfix window
    nmap <leader>c :copen<CR>
    nmap <leader>cc :cclose<CR>

    " Normal editing mode
    map <leader>ne :call EditMode("normal")<cr>

    " Kernel editing mode
    map <leader>ke :call EditMode("kernel")<cr>

    " Ruby editing mode
    map <leader>re :call EditMode("ruby")<cr>

    " Next buffer
    map <leader>bn :bnext<cr>

    " Previous buffer
    map <leader>bp :bprevious<cr>

    " Remove trailing whitespace
    nnoremap <leader>S :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

    " Reformat JSON
    nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>

    " Toggle 'set list'
    nmap <leader>l :set list!<CR>

    " Session List
    " set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
    " nmap <leader>sl :SessionList<CR>
    " nmap <leader>ss :SessionSave<CR>

    " Wrapped lines goes down/up to next row, rather than next line in file.
    nnoremap j gj
    nnoremap k gk

    " Clearing highlighted search
    nmap <silent> <leader><cr> :nohlsearch<cr>

    " visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Some helpers to edit mode - http://vimcasts.org/e/14
    cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Navigate splits more easily
    nnoremap <C-J> <C-W><C-J>
    nnoremap <C-K> <C-W><C-K>
    nnoremap <C-L> <C-W><C-L>
    nnoremap <C-H> <C-W><C-H>
" }

" Plugin Configuration {
    " Unite {
        let g:unite_source_history_yank_enable = 1
        let g:unite_data_directory = expand('~/.vim/tmp/unite')
        call unite#filters#matcher_default#use(['matcher_fuzzy'])
        nnoremap <leader>be :<C-u>Unite -buffer-name=buffer buffer<cr>
    " }

    " delimitMate {
        let g:delimitMate_matchpairs = "(:),[:],{:}"
    " }

    " incsearch {
        map /  <Plug>(incsearch-forward)
        map ?  <Plug>(incsearch-backward)
        map g/ <Plug>(incsearch-stay)
        let g:incsearch#auto_nohlsearch = 1
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
        " disable syntastic for RST (it reports false positives with sphinx)
        let g:syntastic_disabled_filetypes = ['rst']
    " }
" }

" vim: set fmr={,} fdl=0 fdm=marker ft=vim:ts=4:sw=4:noet:nowrap
