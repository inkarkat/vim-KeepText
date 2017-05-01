" Test keeping non-matches of pattern in a line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(3)

2
KeepMatch! /\<...\>/g
call vimtap#Is(@", "foobarbazfornow\n", "deleted global ... text")

3KeepMatch! #bar#
call vimtap#Is(@", "bar\n", "deleted first bar text")

20KeepMatch! a /\<.\{3,6}\>\s*/g
call vimtap#Is(@a, "Erat Donec non tortornisi mollis dolor\n", "deleted global ...[...] text")

call vimtest#SaveOut()
call vimtest#Quit()
