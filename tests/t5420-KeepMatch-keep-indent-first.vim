" Test keeping first match of pattern and indent in a line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(1)

7,9KeepMatch /\<\w\+\>/<
call vimtap#Is(@", "    -indented line\n\t-indented line\n\t    -indented line\n", "deleted except indent and first word")

call vimtest#SaveOut()
call vimtest#Quit()
