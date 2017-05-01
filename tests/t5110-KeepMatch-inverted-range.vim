" Test keeping non-matches of pattern in a range.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(3)

20,$KeepMatch! /^.\+\n/
call vimtap#Is(@", "Erat volutpat. Donec non tortor. Vivamus posuere nisi mollis dolor. Quisque\nporttitor nisi ac elit. Nullam tincidunt ligula vitae nulla.\nEOF\n", "deleted non-empty lines")

7,18KeepMatch! y /.*tab.*\n/
call vimtap#Is(@y, "\ttab-indented line\n\t    softtabstop-indented line\n#\ttab-indented line\n#\t    softtabstop-indented line\n\t    //\ttab-indented line\n\t    //\t    softtabstop-indented line\n", "deleted tab lines")

4,5KeepMatch! x /'[^']\+'/
call vimtap#Is(@x, "'one line''two line'\n", "deleted quoted text")

call vimtest#SaveOut()
call vimtest#Quit()
