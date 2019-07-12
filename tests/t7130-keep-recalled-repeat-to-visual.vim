" Test repeat of keeping recalled pattern text to selection.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(3)

let @/ = ''
execute "7normal \\kk/\\<\\w\\+-indented\<CR>"
call vimtap#Is(@", "     line\n", "keep one line")

11normal \kk?
call vimtap#Is(@", "#    line\n", "recall of normal mode")

16normal Vj.
call vimtap#Is(@", "\t    //   line\n\t    //\t line\n", "repeat of normal mode in two selected lines")

call vimtest#SaveOut()
call vimtest#Quit()
