" Test repeat of keeping recalled pattern text in selection.

runtime plugin/visualrepeat.vim

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(3)

let @/ = ''
execute "7normal Vj\\kk/\\<\\w\\+-indented\<CR>"
call vimtap#Is(@", "     line\n\t line\n", "keep two lines")

11normal \kk?
call vimtap#Is(@", "#    line\n", "recall in one selected line")

16normal v2j.
call vimtap#Is(@", "\t    //   line\n\t    //\t line\n\t    //\t     line\n", "repeat in characterwise selection over three lines")

call vimtest#SaveOut()
call vimtest#Quit()
