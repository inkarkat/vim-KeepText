runtime plugin/KeepText.vim

function! AssertDeletedText( register, exp, description )
    call vimtap#Is(getreg(a:register), a:exp, a:description)
endfunction
