" Test keeping built-in vs. custom text object inside selection.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

edit input.txt
set selection=inclusive
call vimtest#StartTap()
call vimtap#Plan(4)

execute "4normal! 2lv5E\<Esc>"
4normal 2W\zki'
call Assert('"', 4, "is '' is a", "Thone line comment.", "keep a single quoted text inside selection via built-in text object")

" This custom text object clobbers the visual selection.
onoremap iI :<C-u>normal! vT'ot'<CR>
execute "5normal! 2lv5E\<Esc>"
5normal 2W\zkiI
call Assert('"', 5, "is '' is new.", "Thtwo line", "keep a single quoted text inside selection via custom text object")

call vimtest#SaveOut()
call vimtest#Quit()
