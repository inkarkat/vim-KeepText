" Test keeping lines in multiple ranges in the buffer.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(1)

KeepRange /^\s/,/^\S/-1
call vimtap#Is(@", "[default text]\nTuple is (foo, bar, baz, hehe, hihi, hoho) for now.\n<foo> <bar> notyetimplemented </bar> </foo>\nThis 'one line' is a comment.\nThis 'two line' is new.\n\n#   space-indented line\n#	tab-indented line\n#	    softtabstop-indented line\n\n\nErat volutpat. Donec non tortor. Vivamus posuere nisi mollis dolor. Quisque\nporttitor nisi ac elit. Nullam tincidunt ligula vitae nulla.\n\nEOF\n", 'deleted lines')

call vimtest#SaveOut()
call vimtest#Quit()
