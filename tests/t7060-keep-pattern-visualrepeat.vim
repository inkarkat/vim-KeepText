" Test repeat of keeping queried pattern text in selection.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(3)

let @/ = ''
execute "7normal Vj\\kk/\\<\\w\\+-indented\<CR>"
call vimtap#Is(@", "     line\n\t line\n", "keep two lines")

execute "11normal V.\\<\\w\\+-indented\<CR>"
call vimtap#Is(@", "#    line\n", "repeat in one selected line")

execute "16normal v2j.\\<\\w\\+-indented\<CR>"
call vimtap#Is(@", "\t    //   line\n\t    //\t line\n\t    //\t     line\n", "repeat in characterwise selection over three lines")

call vimtest#SaveOut()
call vimtest#Quit()
