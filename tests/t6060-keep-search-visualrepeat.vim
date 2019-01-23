" Test repeat of keeping last search pattern text in selection.

runtime plugin/visualrepeat.vim

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(3)

let @/ = '\<\w\+-indented'
7normal Vj\kkn
call vimtap#Is(@", "     line\n\t line\n", "keep two lines")

11normal V.
call vimtap#Is(@", "#    line\n", "repeat in one selected line")

16normal v2j.
call vimtap#Is(@", "\t    //   line\n\t    //\t line\n\t    //\t     line\n", "repeat in characterwise selection over three lines")

call vimtest#SaveOut()
call vimtest#Quit()
