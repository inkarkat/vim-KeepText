" Test keeping matches of pattern in a line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(3)

20KeepMatch a /\<.\{3,6}\>\s*/g
call vimtap#Is(@a, "volutpat. . Vivamus posuere . Quisque\n", "deleted global non-...[...] text")

3KeepMatch #bar#
call vimtap#Is(@", "<foo> <> notyetimplemented </bar> </foo>\n", "deleted first non-bar text")

2
KeepMatch /\<...\>/g
call vimtap#Is(@", "Tuple is (, , , hehe, hihi, hoho)  .\n", "deleted global non-... text")

call vimtest#SaveOut()
call vimtest#Quit()
