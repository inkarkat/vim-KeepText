" Test repeat of keeping recalled pattern text in register.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(4)

let @/ = ''
execute "7normal \\kk/\\<\\w\\+-indented\<CR>"
call vimtap#Is(@", "     line\n", "keep one line")

let @b = ''
let @c = ''
9normal "b\kk?
call vimtap#Is(@b, "\t     line\n", "recall one line")

11normal "c.
call vimtap#Is(@b, "\t     line\n", "previous register untouched")
call vimtap#Is(@c, "#    line\n", "repeat into different register")

call vimtest#SaveOut()
call vimtest#Quit()
