" Test keeping queried pattern text at various locations in a line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(3)

execute "20normal \"a\\kk/\\<.\\{3,6}\\>\\s*\<CR>"
call vimtap#Is(@a, "volutpat. . Vivamus posuere . Quisque\n", "deleted non-...[...] text")

let @" = ''
execute "5normal \\kk/bar\<CR>"
call vimtap#Is(@", '', "bar does not match in this line")

execute "3normal \\kk/bar\<CR>"
call vimtap#Is(@", "<foo> <> notyetimplemented </> </foo>\n", "deleted non-bar text")

call vimtest#SaveOut()
call vimtest#Quit()
