" KeepText.vim: Keep only {motion} text in lines or the buffer.
"
" DEPENDENCIES:
"   - KeepText.vim autoload script
"
" Copyright: (C) 2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   	002	18-Apr-2013	Use optional visualrepeat#reapply#VisualMode()
"				for normal mode repeat of a visual mapping.
"				When supplying a [count] on such repeat of a
"				previous linewise selection, now [count] number
"				of lines instead of [count] times the original
"				selection is used.
"	001	01-Feb-2013	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_KeepText') || (v:version < 700)
    finish
endif
let g:loaded_KeepText = 1
let s:save_cpo = &cpo
set cpo&vim

" This mapping repeats naturally, because it just sets global things, and Vim is
" able to repeat the g@ on its own.
nnoremap <expr> <Plug>KeepTextLineOperator KeepText#OperatorExpression('KeepText#LineOperator')
nnoremap <expr> <Plug>KeepTextBufferOperator KeepText#OperatorExpression('KeepText#BufferOperator')

" Repeat not defined in visual mode, but enabled through visualrepeat.vim.
vnoremap <silent> <Plug>KeepTextLineVisual
\ :<C-u>call setline('.', getline('.'))<Bar>
\call KeepText#LineOperator('visual', "\<lt>Plug>KeepTextLineVisual")<CR>
vnoremap <silent> <Plug>KeepTextBufferVisual
\ :<C-u>call setline('.', getline('.'))<Bar>
\call KeepText#BufferOperator('visual', "\<lt>Plug>KeepTextBufferVisual")<CR>

" A normal-mode repeat of the visual mapping is triggered by repeat.vim. It
" establishes a new selection at the cursor position, of the same mode and size
" as the last selection.
"   If [count] is given, that number of lines is used / the original size is
"   multiplied accordingly. This has the side effect that a repeat with [count]
"   will persist the expanded size, which is different from what the normal-mode
"   repeat does (it keeps the scope of the original command).
nnoremap <silent> <Plug>KeepTextLineVisual
\ :<C-u>call setline('.', getline('.'))<Bar>
\execute 'normal!' KeepText#VisualMode()<Bar>
\call KeepText#LineOperator('visual', "\<lt>Plug>KeepTextLineVisual")<CR>
nnoremap <silent> <Plug>KeepTextBufferVisual
\ :<C-u>call setline('.', getline('.'))<Bar>
\execute 'normal!' KeepText#VisualMode()<Bar>
\call KeepText#BufferOperator('visual', "\<lt>Plug>KeepTextBufferVisual")<CR>


if ! hasmapto('<Plug>KeepTextLineOperator', 'n')
    nmap <Leader>k <Plug>KeepTextLineOperator
endif
if ! hasmapto('<Plug>KeepTextLineVisual', 'x')
    xmap <Leader>k <Plug>KeepTextLineVisual
endif
if ! hasmapto('<Plug>KeepTextBufferOperator', 'n')
    nmap <Leader>K <Plug>KeepTextBufferOperator
endif
if ! hasmapto('<Plug>KeepTextBufferVisual', 'x')
    xmap <Leader>K <Plug>KeepTextBufferVisual
endif

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
