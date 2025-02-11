" Test repeat of keeping recalled pattern text.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(3)

let @/ = ''
execute "7normal \\kk/\\<\\w\\+-indented\<CR>"
call vimtap#Is(@", "     line\n", "keep one line")

9normal \kk?
call vimtap#Is(@", "\t     line\n", "recall one line")

11normal .
call vimtap#Is(@", "#    line\n", "repeat one line")

call vimtest#SaveOut()
call vimtest#Quit()
