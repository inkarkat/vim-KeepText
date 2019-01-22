" Test keeping last search pattern text at various locations in a line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(3)

let @/ = '\<.\{3,6}\>\s*'
20normal "a\kkn
call vimtap#Is(@a, "volutpat. . Vivamus posuere . Quisque\n", "deleted non-...[...] text")

let @/ = 'bar'
let @" = ''
5normal \kkn
call vimtap#Is(@", '', "bar does not match in this line")

3normal \kkn
call vimtap#Is(@", "<foo> <> notyetimplemented </> </foo>\n", "deleted non-bar text")

call vimtest#SaveOut()
call vimtest#Quit()
