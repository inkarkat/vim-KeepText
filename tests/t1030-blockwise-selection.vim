" Test keeping blockwise selections at various locations.

edit input.txt
set selection=inclusive
call vimtest#StartTap()
call vimtap#Plan(2)

execute "3normal 3W\<C-v>k$\"r\\k"
call AssertDeletedText('r', "Tuple is (foo, bar, baz, hehe,\n<foo> <bar> notyetimplemented \n", "hihi...</bar>... kept")

execute "4normal 2w\<C-v>2ej\\k"
call AssertDeletedText('"', "This '' is a comment.\nThis '' is new.\n", "one line, two line kept")

call vimtest#SaveOut()
call vimtest#Quit()
