" Test keeping replacements of matches of pattern and newline.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(2)

2,5KeepMatchAndNewline /\<...\>/&, /g
call vimtap#Is(@", "Tuple is (, , , hehe, hihi, hoho)  .\n<> <> notyetimplemented </> </>\nThis ' line' is a comment.\nThis ' line' is .\n", "deleted global non-... text")

20,$KeepMatchAndNewline a /\<.\{3,6}\>\s*/\='(' . repeat('x', len(submatch(0))) . ')'/g
call vimtap#Is(@a, "volutpat. . Vivamus posuere . Quisque\nporttitor ac . tincidunt .\n\n\n", "deleted global non-...[...] text")

call vimtest#SaveOut()
call vimtest#Quit()
