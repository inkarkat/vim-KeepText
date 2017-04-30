" Test keeping lines matching pattern in the range.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(1)

5,18KeepText /\<...\>/
call vimtap#Is(@", "\n    space-indented line\n	    softtabstop-indented line\n\n#   space-indented line\n#	    softtabstop-indented line\n\n\n	    //  space-indented line\n	    //	    softtabstop-indented line\n", 'deleted lines')

call vimtest#SaveOut()
call vimtest#Quit()
