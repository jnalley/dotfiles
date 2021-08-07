" setlocal foldmethod=indent
" setlocal foldnestmax=2
" https://github.com/habamax/.vim/blob/aa36f36b498f1d26a10a571dda22477176659fce/after/ftplugin/python.vim

func! FoldIndent() abort
    let indent = indent(v:lnum)/&sw
    let indent_next = indent(nextnonblank(v:lnum+1))/&sw
    if indent_next > indent && getline(v:lnum) !~ '^\s*$'
        return ">" . (indent+1)
    elseif indent != 0
        return indent
    else 
        return -1
    endif
endfunc
setlocal foldexpr=FoldIndent()
setlocal foldmethod=expr
