" Test keeping non-matches of pattern with replacement in a line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(3)

2
KeepMatch! /\<...\>/&, /g
call vimtap#Is(@", "foo, bar, baz, for, now, \n", "replaced deleted global ... text")

3KeepMatch! #bar#XXX#
call vimtap#Is(@", "XXX\n", "replaced deleted first bar text")

20KeepMatch! a /\<.\{3,6}\>\s*/\='(' . repeat('x', len(submatch(0))) . ')'/g
call vimtap#Is(@a, "(xxxxx)(xxxxxx)(xxxx)(xxxxxx)(xxxxx)(xxxxxxx)(xxxxx)\n", "replaced deleted global ...[...] text")

call vimtest#SaveOut()
call vimtest#Quit()
