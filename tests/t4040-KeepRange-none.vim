" Test keeping no lines in the buffer.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(2)

let @" = 'foo'
call vimtap#err#Throws('No lines to keep', 'KeepRange /doesnotexist/', 'Error when pattern does not match')
call vimtap#Is(@", 'foo', 'no change to register')

call vimtest#SaveOut()
call vimtest#Quit()
