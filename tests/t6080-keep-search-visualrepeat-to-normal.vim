" Test repeat of keeping last search pattern text from selection.

runtime plugin/visualrepeat.vim

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(2)

let @/ = '\<\w\+-indented'
7normal Vj\kkn
call vimtap#Is(@", "     line\n\t line\n", "keep two lines")

11normal .
call vimtap#Is(@", "#    line\n#\t line\n", "repeat of visual mode on two lines")

call vimtest#SaveOut()
call vimtest#Quit()
