" KeepText/Matches.vim: Keep only matches in range.
"
" DEPENDENCIES:
"   - ingo/cmdargs/pattern.vim autoload script
"   - ingo/cmdargs/register.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/lines.vim autoload script
"   - ingo/range.vim autoload script
"   - ingo/subst/replacement.vim autoload script
"
" Copyright: (C) 2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.002	19-Jul-2017	ENH: Support :KeepMatch ... /{string}/...
"				replacement that differs from the match.
"   1.00.001	02-May-2017	file creation
let s:save_cpo = &cpo
set cpo&vim

function! KeepText#Matches#Command( startLnum, endLnum, isInvert, arguments )
    let [l:startLnum, l:endLnum] = [ingo#range#NetStart(a:startLnum), ingo#range#NetEnd(a:endLnum)]

    let [l:register, l:remainder] = ingo#cmdargs#register#ParsePrependedWritableRegister(a:arguments, '')
    let [l:separator, l:pattern, l:replacement, l:flags, l:count] = ingo#cmdargs#substitute#Parse(l:remainder)
    if empty(l:separator)
	call ingo#err#Set('Invalid /{pattern}/')
	return 0
    endif
    if empty(l:flags) && empty(l:count) && ! empty(l:replacement) && l:replacement =~# '^\%(&\?[cegiInp#lr]*\)$'
	" Syntax differs from :substitute in that {string} is optional, but
	" {flags} can still be specified.
	let l:flags = l:replacement
	let l:replacement = ''
    endif

    let l:matches = []
    let l:lineNum = line('$')
    try
	execute printf('%d,%dsubstitute%s%s%s\=s:Add(l:matches, l:replacement)%s%s',
	\   l:startLnum, l:endLnum,
	\   l:separator, l:pattern, l:separator,
	\   l:separator, l:flags
	\)

	let l:matchedText = join(l:matches, '')

	let l:deletedLineNum = l:lineNum - line('$')
	let l:endLnum -= l:deletedLineNum

	if a:isInvert
	    call setreg(l:register, l:matchedText, 'V')
	else
	    call ingo#lines#Replace(l:startLnum, l:endLnum, l:matchedText, l:register)
	endif

	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction

function! s:Add( matches, replacement )
    call add(
    \   a:matches,
    \   (empty(a:replacement) ?
    \       submatch(0) :
    \       ingo#subst#replacement#DefaultReplacementOnPredicate(1, {'replacement': a:replacement})
    \   )
    \)
    return ''
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
