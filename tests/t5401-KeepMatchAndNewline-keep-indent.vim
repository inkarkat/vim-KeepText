" Test keeping matches of pattern and indent and newline in a line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(2)

9KeepMatchAndNewline /\<\w\+$/<
call vimtap#Is(@", "\t    softtabstop-indented \n", "deleted except indent")

4,7KeepMatchAndNewline /\<\w\+.\?$/<g
call vimtap#Is(@", "This 'one line' is a \nThis 'two line' is \n\n    space-indented \n", "deleted except indent (in last line) and last word")

call vimtest#SaveOut()
call vimtest#Quit()
