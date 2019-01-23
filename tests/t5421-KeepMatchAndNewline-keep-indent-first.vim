" Test keeping first match of pattern and indent and newline in a line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(1)

7,9KeepMatchAndNewline /\<\w\+\>/<
call vimtap#Is(@", "    -indented line\n\t-indented line\n\t    -indented line\n", "deleted except indent and first word")

call vimtest#SaveOut()
call vimtest#Quit()
