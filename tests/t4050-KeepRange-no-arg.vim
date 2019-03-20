" Test no arguments.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(1)

call vimtap#err#ErrorsLike('^E471: ', 'KeepRange', 'Error when no arguments given')

call vimtest#SaveOut()
call vimtest#Quit()
