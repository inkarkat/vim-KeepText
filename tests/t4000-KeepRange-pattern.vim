" Test keeping lines matching pattern in the buffer.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(1)

KeepRange /\<...\>/
call vimtap#Is(@", "[default text]\n\n    space-indented line\n	    softtabstop-indented line\n\n#   space-indented line\n#	    softtabstop-indented line\n\n\n	    //  space-indented line\n	    //	    softtabstop-indented line\n\nporttitor nisi ac elit. Nullam tincidunt ligula vitae nulla.\n\n", 'deleted lines')

call vimtest#SaveOut()
call vimtest#Quit()
