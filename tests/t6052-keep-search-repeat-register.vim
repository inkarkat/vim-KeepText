" Test repeat of keeping last search pattern text in register.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(4)

let @b = ''
let @c = ''
let @/ = '\<\w\+-indented'
7normal "b\kkn
call vimtap#Is(@b, "     line\n", "keep one line")

9normal .
call vimtap#Is(@b, "\t     line\n", "repeat into same register")

11normal "c.
call vimtap#Is(@b, "\t     line\n", "previous register untouched")
call vimtap#Is(@c, "#    line\n", "repeat into different register")

call vimtest#SaveOut()
call vimtest#Quit()
