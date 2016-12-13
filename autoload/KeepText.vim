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
