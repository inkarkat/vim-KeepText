" KeepText/Objects.vim: Keep only certain objects.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
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
let s:save_cpo = &cpo
set cpo&vim

function! s:KeepTextWithPattern( startLnum, endLnum, register, arguments, mappingPrefix ) abort
    " The count influences the number of lines used, so derive the repeat count
    " from the number of covered lines.
    let [l:startLnum, l:endLnum] = [ingo#range#NetStart(a:startLnum), ingo#range#NetEnd(a:endLnum)]
    let l:count = l:endLnum - l:startLnum + 1

    if ! KeepText#Matches#AndNewline(a:startLnum, a:endLnum, 0, a:register . ' ' . a:arguments)
	execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
    endif

    silent! call repeat#setreg(a:mappingPrefix . 'Line)', a:register)
    silent! call       repeat#set(a:mappingPrefix . 'Line)', l:count)
    silent! call visualrepeat#set(a:mappingPrefix . 'Visual)')
endfunction

function! KeepText#Objects#LastSearchPattern( isQuery, register ) range abort
    call s:KeepTextWithPattern(
    \   a:firstline, a:lastline,
    \   a:register,
    \   '//g<' . (a:isQuery ? 'c' : ''),
    \   "\<Plug>(KeepText" . (a:isQuery ? 'Queried' : 'All') . 'Matches'
    \)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
