" KeepText/Objects.vim: Keep only certain objects.
"
" DEPENDENCIES:
"   - repeat.vim (vimscript #2136) plugin (optional)
"   - visualrepeat.vim (vimscript #3848) plugin (optional)
"
" Copyright: (C) 2019 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.002	24-Jan-2019	Implement repeat.
"   1.00.001	23-Jan-2019	file creation

function! KeepText#Objects#LastSearchPattern( isQuery, register ) range
    " The count influences the number of lines used, so derive the repeat count
    " from the number of covered lines.
    let [l:startLnum, l:endLnum] = [ingo#range#NetStart(a:firstline), ingo#range#NetEnd(a:lastline)]
    let l:count = l:endLnum - l:startLnum + 1

    if ! KeepText#Matches#AndNewline(a:firstline, a:lastline, 0, a:register . ' //g<' . (a:isQuery ? 'c' : ''))
	execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
    endif

    let l:mappingPrefix = "\<Plug>(KeepText" . (a:isQuery ? 'Queried' : 'All') . 'Matches'
    silent! call repeat#setreg(l:mappingPrefix . 'Line)', a:register)
    silent! call       repeat#set(l:mappingPrefix . 'Line)', l:count)
    silent! call visualrepeat#set(l:mappingPrefix . 'Visual)')
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
