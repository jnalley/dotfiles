" Override Colorscheme

if exists('loaded_CustomColors')
  finish
endif

let g:loaded_CustomrColors = 1

augroup CustomColors
  autocmd!
  autocmd ColorScheme * call <SID>CustomColors()
  autocmd VimEnter * call <SID>CustomColors()
augroup END

function! <SID>CustomColors()
  if g:colors_name == 'gruvbox'
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
    highlight DiffAdd    cterm=none ctermfg=11 ctermbg=22 gui=none guifg=#ffff00 guibg=#005f00
    highlight DiffDelete cterm=none ctermfg=11 ctermbg=88 gui=none guifg=#ffff00 guibg=#870000
    highlight DiffChange cterm=none ctermfg=11 ctermbg=88 gui=none guifg=#ffff00 guibg=#870000
    highlight DiffText   cterm=none ctermfg=11 ctermbg=88 gui=underline guifg=#ffff00 guibg=#870000
  endif

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
  highlight User4
        \ ctermfg=172 ctermbg=16
        \ guifg=#df8700 guibg=#000000
  highlight User5
        \ ctermfg=124 ctermbg=16
        \ guifg=#af0000 guibg=#000000

  " ale error/warning
  highlight ALEErrorLine
        \ ctermfg=11 ctermbg=1
        \ guifg=#ffff00 guibg=#800000
  highlight ALEWarningLine
        \ ctermfg=11 ctermbg=130
        \ guifg=#ffff00 guibg=#af5f00
endfunction

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
