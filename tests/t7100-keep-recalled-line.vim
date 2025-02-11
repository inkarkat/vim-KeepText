" Test keeping recalled pattern text at various locations in a line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(3)

execute "20normal \"a\\kk/bar\\|non\<CR>"
call vimtap#Is(@a, "Erat volutpat. Donec  tortor. Vivamus posuere nisi mollis dolor. Quisque\n", "deleted non-...[...] text")

let @" = ''
5normal \kk?
call vimtap#Is(@", '', "bar\\|non does not match in this line")

3normal \kk?
call vimtap#Is(@", "<foo> <> notyetimplemented </> </foo>\n", "deleted non-bar text")

call vimtest#SaveOut()
call vimtest#Quit()
