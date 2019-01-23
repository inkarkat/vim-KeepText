" KeepText/Matches.vim: Keep only matches in range.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2017-2019 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.004	09-Aug-2018	Refactoring: Use
"                               ingo#cmdargs#substitute#GetFlags().
"   1.00.003	19-Sep-2017	FIX: Don't let l:endLnum become smaller than
"				l:startLnum; this can happen when the {pattern}
"				captures multiple line(s) beyond the last line
"				in [range].
"				Refactoring: Make matched text processing
"				configurable by separating s:Command() from
"				KeepText#Matches#Command() and passing in
"				a:Init, a:Adder, a:Joiner Funcrefs.
"				ENH: Add KeepText#Matches#AndNewline() for new
"				:KeepMatchAndNewline command.
"   1.00.002	19-Jul-2017	ENH: Support :KeepMatch ... /{string}/...
"				replacement that differs from the match.
"   1.00.001	02-May-2017	file creation
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
    if empty(l:flags) && empty(l:count) && ! empty(l:replacement) && l:replacement =~# '^\%(' . ingo#cmdargs#substitute#GetFlags(l:indentFlag) . '\)$'
	" Syntax differs from :substitute in that {string} is optional, but
	" {flags} can still be specified.
	let l:flags = l:replacement
	let l:replacement = ''
    endif
    if l:flags =~# l:indentFlag
	let l:flags = ingo#str#trd(l:flags, l:indentFlag)
	" Note: Need to enforce a non-empty match of indent (via \%>1c) because
	" an empty match would clear out the entire line, and that's not desired.
	" Note: Because we search for comment prefixes in the entire range, not
	" every line necessarily has one (or with the same nesting level).
	" Therefore, make the comment prefix optional via
	" a:minNumberOfCommentPrefixesExpr = 0.
	let l:pattern = printf('\%%(%s\%%>1c\|%s\)', escape(ingo#comments#GetSplitIndentPattern(0, l:startLnum, l:endLnum), l:separator), (empty(l:pattern) ? @/ : l:pattern))
    endif

    let l:matches = call(a:Init, [])
    let l:lineNum = line('$')
    try
	execute printf('%d,%dsubstitute%s%s%s\=%s(l:matches, l:replacement)%s%s',
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
function! s:Join( matches )
    return join(a:matches, '')
endfunction
function! KeepText#Matches#Command( startLnum, endLnum, isInvert, arguments )
    return s:Command('s:Init', 's:Add', 's:Join', a:startLnum, a:endLnum, a:isInvert, a:arguments)
endfunction

function! s:InitWithNewline()
    return {}
endfunction
function! s:AddWithNewline( matches, replacement )
    let l:lnum = line('.')
    if ! has_key(a:matches, l:lnum)
	let a:matches[l:lnum] = []
    endif
    return s:Add(a:matches[l:lnum], a:replacement)
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
