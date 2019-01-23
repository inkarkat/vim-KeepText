" Test keeping matches of pattern and indent in a line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(2)

9KeepMatch /\<\w\+$/<
call vimtap#Is(@", "softtabstop-indented line\n", "deleted except indent; ignore last word pattern because no g flag")

4,7KeepMatch /\<\w\+.\?$/<g
call vimtap#Is(@", "This 'one line' is a \nThis 'two line' is \n\nspace-indented \n", "deleted except indent and last word")

call vimtest#SaveOut()
call vimtest#Quit()
