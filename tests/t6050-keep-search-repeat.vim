" Test repeat of keeping last search pattern text.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(2)

let @/ = '\<\w\+-indented'
7normal \kkn
call vimtap#Is(@", "     line\n", "keep one line")

9normal .
call vimtap#Is(@", "\t     line\n", "repeat one line")

call vimtest#SaveOut()
call vimtest#Quit()
