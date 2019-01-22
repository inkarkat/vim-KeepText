" KeepText/Lines.vim: Keep only text in {range} in buffer.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2016-2019 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.001	23-Dec-2016	file creation
let s:save_cpo = &cpo
set cpo&vim

function! KeepText#Lines#Command( startLnum, endLnum, isInvert, arguments )
    let [l:startLnum, l:endLnum] = [ingo#range#NetStart(a:startLnum), ingo#range#NetEnd(a:endLnum)]

    let [l:register, l:range] = ingo#cmdargs#register#ParsePrependedWritableRegister(a:arguments, '')
    let [l:recordedLnums, l:startLnums, l:endLnums, l:didClobberSearchHistory] = ingo#range#lines#Get(l:startLnum, l:endLnum, l:range)
    if empty(l:recordedLnums)
	call ingo#err#Set('No lines to keep')
	return 0
    endif

    "let l:ranges = ingo#range#merge#Merge(ingo#list#Zip(l:startLnums, l:endLnums))
    let l:ranges = ingo#range#merge#FromLnums(l:recordedLnums)
    let l:rangesList = [l:ranges, ingo#range#invert#Invert(l:startLnum, l:endLnum, l:ranges)]

    if a:isInvert | call reverse(l:rangesList) | endif

    let [l:keepLnums, l:deleteLnums] = map(l:rangesList, 's:ObtainLnums(v:val)')
    let [l:keepLines, l:deleteLines] = [map(l:keepLnums, 'getline(v:val)'), map(l:deleteLnums, 'getline(v:val)')]

    try
	call ingo#lines#Replace(l:startLnum, l:endLnum, l:keepLines)
	call setreg(l:register, l:deleteLines, 'V')

	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction
function! s:ObtainLnums( ranges )
    let l:result = []
    for [l:start, l:end] in a:ranges
	call extend(l:result, range(l:start, l:end))
    endfor
    return l:result
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
