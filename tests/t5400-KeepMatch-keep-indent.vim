" Test keeping matches of pattern and indent in a line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(2)

9KeepMatch /\<\w\+$/<
call vimtap#Is(@", "\t    softtabstop-indented \n", "deleted except indent and last word")

4,7KeepMatch /\<\w\+.\?$/<g
call vimtap#Is(@", "This 'one line' is a \nThis 'two line' is \n\n    space-indented \n", "deleted except indent (in last line) and last word")

call vimtest#SaveOut()
call vimtest#Quit()
