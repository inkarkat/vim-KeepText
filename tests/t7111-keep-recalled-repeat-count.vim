" Test repeat of keeping recalled pattern text with count.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(3)

let @/ = ''
execute "7normal \\kk/\\<\\w\\+-indented\<CR>"
call vimtap#Is(@", "     line\n", "keep one line")

9normal \kk?
call vimtap#Is(@", "\t     line\n", "recall one line")

11normal 3.
call vimtap#Is(@", "#    line\n#\t line\n#\t     line\n", "repeat three lines")

call vimtest#SaveOut()
call vimtest#Quit()
