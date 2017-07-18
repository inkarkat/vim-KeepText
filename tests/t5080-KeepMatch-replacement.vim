" Test keeping replacements of matches of pattern in a line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(3)

2
KeepMatch /\<...\>/&, /g
call vimtap#Is(@", "Tuple is (, , , hehe, hihi, hoho)  .\n", "deleted global non-... text")

3KeepMatch #bar#XXX#
call vimtap#Is(@", "<foo> <> notyetimplemented </bar> </foo>\n", "deleted first non-bar text")

20KeepMatch a /\<.\{3,6}\>\s*/\='(' . repeat('x', len(submatch(0))) . ')'/g
call vimtap#Is(@a, "volutpat. . Vivamus posuere . Quisque\n", "deleted global non-...[...] text")

call vimtest#SaveOut()
call vimtest#Quit()
