" KeepText/InSelection.vim: Keep only {motion} text in selection.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2013-2025 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

function! s:FindUnusedSingleWidthCharacter( text )
    return ingo#str#find#NotContaining(a:text, ingo#str#fromrange#GetAsList(32, 126))
endfunction
function! s:SetMarker( position, extraMotion, marker )
    call cursor(a:position[1:2])
    execute 'normal!' a:extraMotion . 'gR' . a:marker
endfunction
function! KeepText#InSelection#SaveSelection( keys ) abort
    let [s:selectionStartPos, s:selectionEndPos, s:selectionStartVirtCol, s:selectionEndVirtCol, s:selectionMode] = [getpos("'<"), getpos("'>"), virtcol("'<"), virtcol("'>"), visualmode()]
    return a:keys
endfunction
function! KeepText#InSelection#KeepText( type )
    let [l:keepStartPos, l:keepEndPos, l:keepStartVirtCol, l:keepEndVirtCol] = [getpos("'["), getpos("']"), virtcol("'["), virtcol("']")]

    if getpos("'<") != s:selectionStartPos || getpos("'>") != s:selectionEndPos || visualmode() !=# s:selectionMode
	" A custom opfunc has clobbered the original user selection; restore it for the
	" following "gv" to work.
	call ingo#selection#Set(s:selectionStartPos, s:selectionEndPos, s:selectionMode)
    endif

    let @" = ''
    silent! normal! gv""y
    let l:originalSelectedText = @"
    if empty(l:originalSelectedText)
	throw 'KeepText: Nothing selected'
    endif

    let [l:isInsideAtFront, l:isInsideAtBack] = [ingo#pos#IsInsideVisualSelection(l:keepStartPos[1:2]), ingo#pos#IsInsideVisualSelection(l:keepEndPos[1:2])]
    if ! l:isInsideAtFront && ! l:isInsideAtBack
	throw 'KeepText: Motion is outside selection'
    elseif ! l:isInsideAtFront
	let l:keepStartPos = s:selectionStartPos
	call ingo#msg#WarningMsg('Only partial overlap at front; extending selection')
    elseif ! l:isInsideAtBack
	let l:keepEndPos = s:selectionEndPos
	call ingo#msg#WarningMsg('Only partial overlap at back; extending selection')
    endif

    let l:unusedSingleWidthCharacter = s:FindUnusedSingleWidthCharacter(l:originalSelectedText)

    " Restore change marks; the yank has set those to the visual selection.
    call ingo#change#Set(l:keepStartPos, l:keepEndPos)

    " Note: Need to use an "inclusive" selection to make `] include the
    " last moved-over character.
    let l:save_selection = &selection
    set selection=inclusive
    try
	" We cannot directly remove the text to keep, as that would affect the
	" size of the selection. Instead, yank the text, and add markers for the
	" start and end (using gR, so that any Tab / double-width character does
	" not affect the size). With those markers, we can later cut out the
	" text to keep.
	execute 'normal! g`[' . (a:type ==# 'line' ? 'V' : 'v') . 'g`]y'

	call s:SetMarker(l:keepEndPos,   (a:type ==# 'line' ? '$' : ''), l:unusedSingleWidthCharacter)
	call s:SetMarker(l:keepStartPos, (a:type ==# 'line' ? '0' : ''), l:unusedSingleWidthCharacter)
    finally
	let &selection = l:save_selection
    endtry

    " Replace the selection with the text to be kept.
    call ingo#compat#setpos("'<", s:selectionStartPos)
    call ingo#compat#setpos("'>", s:selectionEndPos)

    let l:selectionExtensionPre = ''
    let l:selectionExtensionPost = ''
    if s:selectionMode ==# "\<C-v>"
	" The end of the kept text can fall outside the block, if the last
	" selected line is shorter than the end of the kept text. (The check for
	" partial overlap at the beginning only considers the borders, not
	" blocks.) Try to extend till the end; if that's not possible, make the
	" selection zaggy, to ensure that all of the kept text falls inside the
	" selection.
	" Note: We cannot set virtualedit=block; that would add trailing
	" whitespace to the kept text. Instead, make the extension motions
	" "greedy", i.e. first jump to the absolute border, and then try to
	" reduce to the target column. If that exact place cannot be reached, we
	" at least include everything we need (and more).
	let l:selectionExtensionPost = (s:selectionEndVirtCol < l:keepEndVirtCol ?
	\   (ingo#strdisplaywidth#HasMoreThan(getline(s:selectionEndPos[1]), l:keepEndVirtCol - 1) ?
	\       '$' . l:keepEndVirtCol . '|' :
	\       '$'
	\   ) :
	\   ''
	\)

	" Same for front.
	if s:selectionStartVirtCol > l:keepStartVirtCol
	    let l:selectionExtensionPre = '0' . l:keepStartVirtCol . '|'
	endif

	" Turn the kept text into blockwise mode; otherwise, each selected line
	" will receive a copy of it, but we only want this in the first selected
	" line.
	call setreg('"', '', 'ab')
    endif
    execute 'normal! g`<' . l:selectionExtensionPre . s:selectionMode . 'g`>' . l:selectionExtensionPost . '""p'

    let l:isSingleCharacterMotion = (l:keepStartPos == l:keepEndPos)
    let l:replacement =escape(l:unusedSingleWidthCharacter, '\')
    let l:surroundingText = substitute(@",
    \   (l:isSingleCharacterMotion ?
    \       '\V\C' . l:replacement :
    \       '\V\C' . l:replacement . '\_.\*' . l:replacement
    \   ),
    \   '', ''
    \)
    unlet! s:selectionStartPos s:selectionEndPos s:selectionStartVirtCol s:selectionEndVirtCol s:selectionMode
    return l:surroundingText
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
