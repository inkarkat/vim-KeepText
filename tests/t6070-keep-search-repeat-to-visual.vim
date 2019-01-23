" Test repeat of keeping last search pattern text to selection.

runtime plugin/visualrepeat.vim

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(2)

let @/ = '\<\w\+-indented'
7normal \kkn
call vimtap#Is(@", "     line\n", "keep one line")

11normal Vj.
call vimtap#Is(@", "#    line\n#\t line\n", "repeat of normal mode in two selected lines")

call vimtest#SaveOut()
call vimtest#Quit()
