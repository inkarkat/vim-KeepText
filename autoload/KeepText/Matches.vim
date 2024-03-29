" KeepText/Matches.vim: Keep only matches in range.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2017-2022 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

function! s:Command( Init, Adder, Joiner, startLnum, endLnum, isInvert, arguments )
    let l:indentFlag = '<'
    let [l:startLnum, l:endLnum] = [ingo#range#NetStart(a:startLnum), ingo#range#NetEnd(a:endLnum)]

    let [l:register, l:remainder] = ingo#cmdargs#register#ParsePrependedWritableRegister(a:arguments, '')
    let [l:separator, l:pattern, l:replacement, l:flags, l:count] = ingo#cmdargs#substitute#Parse(l:remainder, {'additionalFlags': l:indentFlag})
    if empty(l:separator)
	call ingo#err#Set('Invalid /{pattern}/')
	return 0
    endif
    if empty(l:flags) && empty(l:count) && ! empty(l:replacement) && l:replacement =~# ingo#regexp#Anchored(ingo#cmdargs#substitute#GetFlags(l:indentFlag))
	" Syntax differs from :substitute in that {string} is optional, but
	" {flags} can still be specified.
	let l:flags = l:replacement
	let l:replacement = ''
    endif
    if l:flags =~# l:indentFlag
	let l:flags = ingo#str#trd(l:flags, l:indentFlag)

	let l:indentsByLnum = map(
	\   ingo#dict#FromKeys(range(l:startLnum, l:endLnum), ''),
	\   'ingo#comments#SplitIndentAndText(getline(0 + v:key))[0]'
	\)
    else
	let l:indentsByLnum = {}
    endif

    let l:matches = call(a:Init, [])
    let l:lineNum = line('$')
    try
	execute printf('%d,%dsubstitute%s%s%s\=%s(l:indentsByLnum, l:matches, l:replacement)%s%s',
	\   l:startLnum, l:endLnum,
	\   l:separator, l:pattern, l:separator,
	\   a:Adder,
	\   l:separator, l:flags
	\)

	let l:matchedText = call(a:Joiner, [l:matches])

	let l:deletedLineNum = l:lineNum - line('$')
	let l:endLnum = max([l:startLnum, l:endLnum - l:deletedLineNum])

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

function! s:Init()
    return []
endfunction
function! s:Add( prefixesByLnum, matches, replacement )
    let l:match = (empty(a:replacement) ?
    \   submatch(0) :
    \   ingo#subst#replacement#DefaultReplacementOnPredicate(1, {'replacement': a:replacement})
    \)

    let l:currentLnum = line('.')
    let l:prefix = get(a:prefixesByLnum, l:currentLnum, '')
    let a:prefixesByLnum[l:currentLnum] = ''  | " Consume each prefix only once per line.

    if ! empty(l:prefix)
	" Join indent prefix with match that has its indent removed.
	let l:match = l:prefix . substitute(l:match, '^\s\+', '', '')
    endif

    call add(a:matches, l:match)

    return ''
endfunction
function! s:Join( matches )
    return join(a:matches, '')
endfunction
function! KeepText#Matches#Command( startLnum, endLnum, isInvert, arguments )
    return s:Command('s:Init', 's:Add', 's:Join', a:startLnum, a:endLnum, a:isInvert, a:arguments)
endfunction

function! s:InitWithNewline()
    return {}
endfunction
function! s:AddWithNewline( prefixesByLnum, matches, replacement )
    let l:lnum = line('.')
    if ! has_key(a:matches, l:lnum)
	let a:matches[l:lnum] = []
    endif
    return s:Add(a:prefixesByLnum, a:matches[l:lnum], a:replacement)
endfunction
function! s:JoinWithNewline( matches )
    let l:result = ''
    for l:lnum in sort(keys(a:matches), 'ingo#collections#numsort')
	let l:lineMatches = s:Join(a:matches[l:lnum])
	let l:result .= l:lineMatches . (l:lineMatches =~# '\n$' ? '' : "\n")
    endfor
    return l:result
endfunction
function! KeepText#Matches#AndNewline( startLnum, endLnum, isInvert, arguments )
    return s:Command('s:InitWithNewline', 's:AddWithNewline', 's:JoinWithNewline', a:startLnum, a:endLnum, a:isInvert, a:arguments)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
