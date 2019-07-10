" KeepText.vim: Keep only {motion} text in lines or the buffer.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2013-2019 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_KeepText') || (v:version < 700)
    finish
endif
let g:loaded_KeepText = 1
let s:save_cpo = &cpo
set cpo&vim

"- commands --------------------------------------------------------------------

command! -bar -bang -range=% -nargs=+ KeepRange           call setline(<line1>, getline(<line1>)) | if ! KeepText#Lines#Command(<line1>, <line2>, <bang>0, <q-args>) | echoerr ingo#err#Get() | endif
command!      -bang -range   -nargs=+ KeepMatch           call setline(<line1>, getline(<line1>)) | if ! KeepText#Matches#Command(<line1>, <line2>, <bang>0, <q-args>) | echoerr ingo#err#Get() | endif
command!      -bang -range   -nargs=+ KeepMatchAndNewline call setline(<line1>, getline(<line1>)) | if ! KeepText#Matches#AndNewline(<line1>, <line2>, <bang>0, <q-args>) | echoerr ingo#err#Get() | endif


"- mappings --------------------------------------------------------------------

" This mapping repeats naturally, because it just sets global things, and Vim is
" able to repeat the g@ on its own.
nnoremap <expr> <Plug>(KeepTextLineOperator)      KeepText#OperatorExpression('KeepText#LineOperator')
nnoremap <expr> <Plug>(KeepTextBufferOperator)    KeepText#OperatorExpression('KeepText#BufferOperator')
nnoremap <expr> <Plug>(KeepTextSelectionOperator) KeepText#OperatorExpression('KeepText#SelectionOperator')

" Repeat not defined in visual mode, but enabled through visualrepeat.vim.
vnoremap <silent> <Plug>(KeepTextLineVisual)
\ :<C-u>call setline('.', getline('.'))<Bar>
\call KeepText#LineOperator('visual', 1)<CR>
vnoremap <silent> <Plug>(KeepTextBufferVisual)
\ :<C-u>call setline('.', getline('.'))<Bar>
\call KeepText#BufferOperator('visual', 1)<CR>

" A normal-mode repeat of the visual mapping is triggered by repeat.vim. It
" establishes a new selection at the cursor position, of the same mode and size
" as the last selection.
"   If [count] is given, that number of lines is used / the original size is
"   multiplied accordingly. This has the side effect that a repeat with [count]
"   will persist the expanded size, which is different from what the normal-mode
"   repeat does (it keeps the scope of the original command).
nnoremap <silent> <Plug>(KeepTextLineVisual)
\ :<C-u>call setline('.', getline('.'))<Bar>
\execute 'normal!' KeepText#VisualMode()<Bar>
\call KeepText#LineOperator('visual', 1)<CR>
nnoremap <silent> <Plug>(KeepTextBufferVisual)
\ :<C-u>call setline('.', getline('.'))<Bar>
\execute 'normal!' KeepText#VisualMode()<Bar>
\call KeepText#BufferOperator('visual', 1)<CR>


nnoremap <Plug>(KeepTextAllMatchesLine)
\ :call KeepText#Objects#LastSearchPattern(0, v:register)<Home>call setline('.', getline('.'))<Bar><CR>
vnoremap <Plug>(KeepTextAllMatchesVisual)
\ :<C-u>call setline("'<", getline("'<"))<Bar>
\'<,'>call KeepText#Objects#LastSearchPattern(0, v:register)<CR>
nnoremap <Plug>(KeepTextAllMatchesVisual)
\ :<C-u>call setline('.', getline('.'))<Bar>
\execute 'normal!' KeepText#VisualMode()<Bar>
\'<,'>call KeepText#Objects#LastSearchPattern(0, v:register)<CR>

nnoremap <Plug>(KeepTextQueriedMatchesLine)
\ :call KeepText#Objects#LastSearchPattern(1, v:register)<Home>call setline('.', getline('.'))<Bar><CR>
vnoremap <Plug>(KeepTextQueriedMatchesVisual)
\ :<C-u>call setline("'<", getline("'<"))<Bar>
\'<,'>call KeepText#Objects#LastSearchPattern(1, v:register)<CR>
nnoremap <Plug>(KeepTextQueriedMatchesVisual)
\ :<C-u>call setline('.', getline('.'))<Bar>
\execute 'normal!' KeepText#VisualMode()<Bar>
\'<,'>call KeepText#Objects#LastSearchPattern(1, v:register)<CR>

nnoremap <Plug>(KeepTextQueriedQueriedPatternMatchesLine)
\ :call KeepText#Objects#QueriedPattern(0, v:register)<Bar>if ingo#err#IsSet()<Bar>echoerr ingo#err#Get()<Bar>endif<Home>call setline('.', getline('.'))<Bar><CR>
vnoremap <Plug>(KeepTextQueriedQueriedPatternMatchesVisual)
\ :<C-u>call setline("'<", getline("'<"))<Bar>
\'<,'>call KeepText#Objects#QueriedPattern(0, v:register)<Bar>if ingo#err#IsSet()<Bar>echoerr ingo#err#Get()<Bar>endif<CR>
nnoremap <Plug>(KeepTextQueriedQueriedPatternMatchesVisual)
\ :<C-u>call setline('.', getline('.'))<Bar>
\execute 'normal!' KeepText#VisualMode()<Bar>
\'<,'>call KeepText#Objects#QueriedPattern(0, v:register)<Bar>if ingo#err#IsSet()<Bar>echoerr ingo#err#Get()<Bar>endif<CR>

nnoremap <Plug>(KeepTextQueriedRecalledPatternMatchesLine)
\ :call KeepText#Objects#QueriedPattern(1, v:register)<Bar>if ingo#err#IsSet()<Bar>echoerr ingo#err#Get()<Bar>endif<Home>call setline('.', getline('.'))<Bar><CR>
vnoremap <Plug>(KeepTextQueriedRecalledPatternMatchesVisual)
\ :<C-u>call setline("'<", getline("'<"))<Bar>
\'<,'>call KeepText#Objects#QueriedPattern(1, v:register)<Bar>if ingo#err#IsSet()<Bar>echoerr ingo#err#Get()<Bar>endif<CR>
nnoremap <Plug>(KeepTextQueriedRecalledPatternMatchesVisual)
\ :<C-u>call setline('.', getline('.'))<Bar>
\execute 'normal!' KeepText#VisualMode()<Bar>
\'<,'>call KeepText#Objects#QueriedPattern(1, v:register)<Bar>if ingo#err#IsSet()<Bar>echoerr ingo#err#Get()<Bar>endif<CR>



if ! hasmapto('<Plug>(KeepTextLineOperator)', 'n')
    nmap <Leader>k <Plug>(KeepTextLineOperator)
endif
if ! hasmapto('<Plug>(KeepTextLineVisual)', 'x')
    xmap <Leader>k <Plug>(KeepTextLineVisual)
endif
if ! hasmapto('<Plug>(KeepTextBufferOperator)', 'n')
    nmap g<Leader>k <Plug>(KeepTextBufferOperator)
endif
if ! hasmapto('<Plug>(KeepTextBufferVisual)', 'x')
    xmap g<Leader>k <Plug>(KeepTextBufferVisual)
endif
if ! hasmapto('<Plug>(KeepTextSelectionOperator)', 'n')
    nmap <Leader>zk <Plug>(KeepTextSelectionOperator)
endif

if ! hasmapto('<Plug>(KeepTextAllMatchesLine)', 'n')
    nmap <Leader>kkn <Plug>(KeepTextAllMatchesLine)
endif
if ! hasmapto('<Plug>(KeepTextAllMatchesVisual)', 'v')
    xmap <Leader>kkn <Plug>(KeepTextAllMatchesVisual)
endif
if ! hasmapto('<Plug>(KeepTextQueriedMatchesLine)', 'n')
    nmap <Leader>kkN <Plug>(KeepTextQueriedMatchesLine)
endif
if ! hasmapto('<Plug>(KeepTextQueriedMatchesVisual)', 'v')
    xmap <Leader>kkN <Plug>(KeepTextQueriedMatchesVisual)
endif
if ! hasmapto('<Plug>(KeepTextQueriedQueriedPatternMatchesLine)', 'n')
    nmap <Leader>kk/ <Plug>(KeepTextQueriedQueriedPatternMatchesLine)
endif
if ! hasmapto('<Plug>(KeepTextQueriedQueriedPatternMatchesVisual)', 'v')
    xmap <Leader>kk/ <Plug>(KeepTextQueriedQueriedPatternMatchesVisual)
endif
if ! hasmapto('<Plug>(KeepTextQueriedRecalledPatternMatchesLine)', 'n')
    nmap <Leader>kk? <Plug>(KeepTextQueriedRecalledPatternMatchesLine)
endif
if ! hasmapto('<Plug>(KeepTextQueriedRecalledPatternMatchesVisual)', 'v')
    xmap <Leader>kk? <Plug>(KeepTextQueriedRecalledPatternMatchesVisual)
endif

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
