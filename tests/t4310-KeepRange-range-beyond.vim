" Test specifying a range extending the command range.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(1)

2,13KeepRange /^#   space-indented/,/^Erat/
call vimtap#Is(@", "Tuple is (foo, bar, baz, hehe, hihi, hoho) for now.\n<foo> <bar> notyetimplemented </bar> </foo>\nThis 'one line' is a comment.\nThis 'two line' is new.\n\n    space-indented line\n	tab-indented line\n	    softtabstop-indented line\n\n", 'deleted lines')

call vimtest#SaveOut()
call vimtest#Quit()
