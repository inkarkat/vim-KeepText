" Test keeping lines in range in the buffer.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(1)

KeepText /^#   space-indented/,/^Erat/
call vimtap#Is(@", "[default text]\nTuple is (foo, bar, baz, hehe, hihi, hoho) for now.\n<foo> <bar> notyetimplemented </bar> </foo>\nThis 'one line' is a comment.\nThis 'two line' is new.\n\n    space-indented line\n	tab-indented line\n	    softtabstop-indented line\n\nporttitor nisi ac elit. Nullam tincidunt ligula vitae nulla.\n\nEOF\n", 'deleted lines')

call vimtest#SaveOut()
call vimtest#Quit()
