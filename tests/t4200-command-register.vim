" Test deleting into specified register.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(2)

let @" = 'foo'
KeepText! b /^This/
call vimtap#Is(@b, "This 'one line' is a comment.\nThis 'two line' is new.\n", 'deleted lines in specified register')
call vimtap#Is(@", 'foo', 'no change to default register')

call vimtest#SaveOut()
call vimtest#Quit()
