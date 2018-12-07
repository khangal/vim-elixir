if exists("b:did_indent")
  finish
end
let b:did_indent = 1

setlocal indentexpr=ElixirIndent(v:lnum)

setlocal nolisp
setlocal autoindent
setlocal indentkeys+=<:>,0=},0=)
setlocal indentkeys+==after,=catch,=do,=else,=end,=rescue,
setlocal indentkeys+==->,=\|>,=<>,0},0],0)

let s:indent_regex = '\(do\|->\|fn\|[([{=]\|else\|case\)$'
let s:deindent_regex = '^\s*\(end[),]\?\|[)\]}]\|else\)$'

function! ElixirIndent(lnum)
  let plnum = prevnonblank(a:lnum-1)

  let pline = substitute(getline(plnum), '#.*$', '', '')
  let line = substitute(getline(a:lnum), '#.*$', '', '')
  let pindent = indent(plnum)

  let ind = pindent

  if synIDattr(synID(a:lnum, 1, 1), "name") =~ "Doc"
    return -1
  endif

  if indent(a:lnum) <= pindent - shiftwidth()
    " if user already dedented

    if line =~ '^\s*$'
      return pindent
    endif
    return -1
  endif

  if pline =~ s:indent_regex
    " this line opened a block
    let ind += shiftwidth()
  endif

  if line =~ s:deindent_regex
    " this line closed a block
    let ind -= shiftwidth()
  endif

  return ind
endfunction
