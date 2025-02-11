" Test repeat of keeping queried pattern text.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(2)

let @/ = ''
execute "7normal \\kk/\\<\\w\\+-indented\<CR>"
call vimtap#Is(@", "     line\n", "keep one line")

execute "9normal .\\<\\w\\+-indented\<CR>"
call vimtap#Is(@", "\t     line\n", "repeat one line")

call vimtest#SaveOut()
call vimtest#Quit()
