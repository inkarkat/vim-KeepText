" Test entering no pattern.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(1)

let @" = ''
execute "5normal \\kk/\<CR>"
call vimtap#Is(@", '', "Register not updated")

call vimtest#SaveOut()
call vimtest#Quit()
