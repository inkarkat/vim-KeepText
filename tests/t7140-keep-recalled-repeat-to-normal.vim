" Test repeat of keeping recalled pattern text from selection.

runtime plugin/visualrepeat.vim

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(3)

execute "7normal \\kk/\\<\\w\\+-indented\<CR>"
call vimtap#Is(@", "     line\n", "keep one line")

11normal 2V\kk?
call vimtap#Is(@", "#    line\n#\t line\n", "recall in visual mode on two lines")

16normal .
call vimtap#Is(@", "\t    //   line\n\t    //\t line\n", "repeat of visual mode on two lines")

call vimtest#SaveOut()
call vimtest#Quit()
