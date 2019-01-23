" Test keeping all matches of pattern and indent in a line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(1)

7,9KeepMatch /\<\w\zs\w*\ze\w\>/<g
call vimtap#Is(@", "    se-id le\n\ttb-id le\n\t    sp-id le\n", "deleted except indent and word middles")

call vimtest#SaveOut()
call vimtest#Quit()
