" Test keeping all lines in the buffer.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(1)

KeepRange %
call vimtap#Is(@", "", 'no deleted lines')

call vimtest#SaveOut()
call vimtest#Quit()
