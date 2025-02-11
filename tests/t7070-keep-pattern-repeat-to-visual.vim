" Test repeat of keeping queried pattern text to selection.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(2)

let @/ = ''
execute "7normal \\kk/\\<\\w\\+-indented\<CR>"
call vimtap#Is(@", "     line\n", "keep one line")

execute "11normal Vj.\\<\\w\\+-indented\<CR>"
call vimtap#Is(@", "#    line\n#\t line\n", "repeat of normal mode in two selected lines")

call vimtest#SaveOut()
call vimtest#Quit()
