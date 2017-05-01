" Test keeping lines not matching pattern in the buffer.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(1)

KeepRange! /^This/
call vimtap#Is(@", "This 'one line' is a comment.\nThis 'two line' is new.\n", 'deleted lines')

call vimtest#SaveOut()
call vimtest#Quit()
