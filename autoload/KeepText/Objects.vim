" KeepText/Objects.vim: Keep only certain objects.
"
" DEPENDENCIES:
"
" Copyright: (C) 2019 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.001	23-Jan-2019	file creation

function! KeepText#Objects#LastSearchPattern( isQuery, register ) range
    if ! KeepText#Matches#AndNewline(a:firstline, a:lastline, 0, a:register . ' //g<' . (a:isQuery ? 'c' : ''))
	execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
    endif
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
