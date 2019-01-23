call vimtest#AddDependency('vim-ingo-library')
if g:runVimTest =~# '-\%(visual\)\?repeat[.-]'
    call vimtest#AddDependency('vim-repeat')
endif

runtime plugin/KeepText.vim

function! AssertDeletedText( register, exp, description )
    call vimtap#Is(getreg(a:register), a:exp, a:description)
endfunction
function! AssertKeptLine( lnum, exp, description )
    let l:lines = (type(a:lnum) == type([]) ? join(getline(a:lnum[0], a:lnum[1]), "\n") : getline(a:lnum))
    call vimtap#Is(l:lines, a:exp, a:description)
endfunction
function! Assert( register, lnum, expDeleted, expKept, description )
    call AssertDeletedText(a:register, a:expDeleted, a:description)
    call AssertKeptLine(a:lnum, a:expKept, a:description)
endfunction
