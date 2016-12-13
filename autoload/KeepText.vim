" KeepText.vim: Keep only {motion} text in lines or the buffer.
"
" DEPENDENCIES:
"   - ingo/comments.vim autoload script
"   - ingo/lines.vim autoload script
"   - ingo/register.vim autoload script
"   - repeat.vim (vimscript #2136) autoload script (optional)
"   - visualrepeat.vim (vimscript #3848) autoload script (optional)
"   - visualrepeat/reapply.vim autoload script (optional)
"
" Copyright: (C) 2013-2016 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.005	14-Dec-2016	Implement <Leader>zk mapping via special
"				KeepText#KeepTextInSelection() function.
"	004	14-Dec-2016	Handle selection overlapping with indent: Do not
"				add indent then.
"	003	13-Dec-2016	ENH: Keep indent [+ comment prefix] in text.
"				For blockwise selections, apply the indent to
"				every line.
"	002	02-Dec-2016	Complete implementation.
"	001	18-Apr-2013	file creation
let s:save_cpo = &cpo
set cpo&vim

function! KeepText#VisualMode()
    let l:keys = "1v\<Esc>"
    silent! let l:keys = visualrepeat#reapply#VisualMode(0)
    return l:keys
endfunction

function! KeepText#KeepText( type, startLnum, endLnum )
    let l:lastLnum = line('$')
    let l:indent = ingo#comments#SplitIndentAndText(getline(a:startLnum))[0]

    if a:type ==# 'visual'
	let l:isBlockWise = (visualmode() ==# "\<C-v>")
	let l:startCol = col("'<")

	execute 'normal! gvd'
    else
	let l:isBlockWise = (a:type ==# 'block')
	let l:startCol = col("'[")

	" Note: Need to use an "inclusive" selection to make `] include the
	" last moved-over character.
	let l:save_selection = &selection
	set selection=inclusive
	try
	    execute 'normal! g`[' . (a:type ==# 'line' ? 'V' : 'v') . 'g`]d'
	finally
	    let &selection = l:save_selection
	endtry
    endif
    let l:keptLineOffset = line('$') - l:lastLnum

    if l:startCol <= len(l:indent)
	let l:indent = ''
    endif
    if l:isBlockWise && ! empty(l:indent)
	" Insert the indent before _every_ line.
	let l:keptText = substitute(@", '^\|\n\zs', escape(l:indent, '\&'), 'g')
    else
	let l:keptText = l:indent . @"
    endif

    " Replace the range with the text to be kept. Store the replaced lines
    " (which don't contain the text to be kept any longer, it was deleted) again
    " in the default register, and return that.
    call ingo#lines#Replace(a:startLnum, a:endLnum + l:keptLineOffset, l:keptText, '"')

    return @"
endfunction
function! s:FindUnusedSingleWidthCharacter( text )
    return ingo#str#find#NotContaining(a:text, map(range(32, 126), 'nr2char(v:val)'))
endfunction
function! s:SetMarker( position, extraMotion, marker )
    call cursor(a:position[1:2])
    execute 'normal!' a:extraMotion . 'gR' . a:marker
endfunction
function! KeepText#KeepTextInSelection( type )
    let [l:selectionStartPos, l:selectionEndPos, l:selectionStartVirtCol, l:selectionEndVirtCol, l:selectionMode] = [getpos("'<"), getpos("'>"), virtcol("'<"), virtcol("'>"), visualmode()]
    let [l:keepStartPos, l:keepEndPos, l:keepStartVirtCol, l:keepEndVirtCol] = [getpos("'["), getpos("']"), virtcol("'["), virtcol("']")]

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
	let l:keepStartPos = l:selectionStartPos
	call ingo#msg#WarningMsg('Only partial overlap at front; extending selection')
    elseif ! l:isInsideAtBack
	let l:keepEndPos = l:selectionEndPos
	call ingo#msg#WarningMsg('Only partial overlap at back; extending selection')
    endif

    let l:unusedSingleWidthCharacter = s:FindUnusedSingleWidthCharacter(l:originalSelectedText)

    " Restore change marks; the yank has set those to the visual selection.
    call setpos("'[", l:keepStartPos)
    call setpos("']", l:keepEndPos)

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
    call ingo#compat#setpos("'<", l:selectionStartPos)
    call ingo#compat#setpos("'>", l:selectionEndPos)

    let l:selectionExtensionPre = ''
    let l:selectionExtensionPost = ''
    if l:selectionMode ==# "\<C-v>"
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
	let l:selectionExtensionPost = (l:selectionEndVirtCol < l:keepEndVirtCol ?
	\   (ingo#strdisplaywidth#HasMoreThan(getline(l:selectionEndPos[1]), l:keepEndVirtCol - 1) ?
	\       '$' . l:keepEndVirtCol . '|' :
	\       '$'
	\   ) :
	\   ''
	\)

	" Same for front.
	if l:selectionStartVirtCol > l:keepStartVirtCol
	    let l:selectionExtensionPre = '0' . l:keepStartVirtCol . '|'
	endif

	" Turn the kept text into blockwise mode; otherwise, each selected line
	" will receive a copy of it, but we only want this in the first selected
	" line.
	call setreg('"', '', 'ab')
    endif
    execute 'normal! g`<' . l:selectionExtensionPre . l:selectionMode . 'g`>' . l:selectionExtensionPost . '""p'

    let l:isSingleCharacterMotion = (l:keepStartPos == l:keepEndPos)
    let l:replacement =escape(l:unusedSingleWidthCharacter, '\')
    let l:surroundingText = substitute(@",
    \   (l:isSingleCharacterMotion ?
    \       '\V\C' . l:replacement :
    \       '\V\C' . l:replacement . '\_.\*' . l:replacement
    \   ),
    \   '', ''
    \)
    return l:surroundingText
endfunction

function! KeepText#LineOperator( type, ... )
    silent! call repeat#setreg("\<Plug>(KeepTextLineVisual)", v:register)

    let l:save_count = v:count
    let l:save_register = v:register
    let [l:startLnum, l:endLnum] = (a:type ==# 'visual' ?
    \   [line("'<"), line("'>")] :
    \   [line("'["), line("']")]
    \)

    let l:surroundingText = ingo#register#KeepRegisterExecuteOrFunc(function('KeepText#KeepText'), a:type, l:startLnum, l:endLnum)
    call setreg(l:save_register, l:surroundingText)

    if a:0
	silent! call repeat#set("\<Plug>(KeepTextLineVisual)", l:save_count)
    endif
    silent! call visualrepeat#set("\<Plug>(KeepTextLineVisual)", l:save_count)
endfunction
function! KeepText#BufferOperator( type, ... )
    silent! call repeat#setreg("\<Plug>(KeepTextBufferVisual)", v:register)

    let l:save_count = v:count
    let l:save_register = v:register
    let [l:startLnum, l:endLnum] = [1, line('$')]

    let l:surroundingText = ingo#register#KeepRegisterExecuteOrFunc(function('KeepText#KeepText'), a:type, l:startLnum, l:endLnum)
    call setreg(l:save_register, l:surroundingText)

    if a:0 && a:1
	silent! call repeat#set("\<Plug>(KeepTextBufferVisual)", l:save_count)
    endif
    silent! call visualrepeat#set("\<Plug>(KeepTextBufferVisual)", l:save_count)
endfunction
function! KeepText#SelectionOperator( type, ... )
    let l:save_register = v:register
    try
	let l:surroundingText = ingo#register#KeepRegisterExecuteOrFunc(function('KeepText#KeepTextInSelection'), a:type)
	call setreg(l:save_register, l:surroundingText)
    catch /^KeepText:/
	call ingo#msg#CustomExceptionMsg('KeepText')
    endtry
endfunction

function! KeepText#OperatorExpression( opfunc )
    let &opfunc = a:opfunc

    let l:keys = 'g@'

    if ! &l:modifiable || &l:readonly
	" Probe for "Cannot make changes" error and readonly warning via a no-op
	" dummy modification.
	" In the case of a nomodifiable buffer, Vim will abort the normal mode
	" command chain, discard the g@, and thus not invoke the operatorfunc.
	let l:keys = ":call setline('.', getline('.'))\<CR>" . l:keys
    endif

    return l:keys
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
