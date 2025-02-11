" Test that the queried pattern does not affect the last search pattern.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(2)

let @/ = 'Erat volutpat'
execute "3normal \\kk/bar\<CR>"
call vimtap#Is(@", "<foo> <> notyetimplemented </> </foo>\n", "deleted non-bar text")
call vimtap#Is(@/, 'Erat volutpat', "last search pattern is unchanged")

call vimtest#SaveOut()
call vimtest#Quit()
