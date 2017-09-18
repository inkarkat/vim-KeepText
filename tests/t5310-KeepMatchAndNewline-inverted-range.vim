" Test keeping non-matches of pattern and newline in a range.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(4)

20,$KeepMatchAndNewline! /^.\+\n/
call vimtap#Is(@", "Erat volutpat. Donec non tortor. Vivamus posuere nisi mollis dolor. Quisque\nporttitor nisi ac elit. Nullam tincidunt ligula vitae nulla.\nEOF\n", "deleted non-empty lines")

7,18KeepMatchAndNewline! y /.*tab.*\n/
call vimtap#Is(@y, "\ttab-indented line\n\t    softtabstop-indented line\n#\ttab-indented line\n#\t    softtabstop-indented line\n\t    //\ttab-indented line\n\t    //\t    softtabstop-indented line\n", "deleted tab lines")

4,5KeepMatchAndNewline! x /'[^']\+'/
call vimtap#Is(@x, "'one line'\n'two line'\n", "deleted quoted text")

2,3KeepMatchAndNewline! /\<...\>/g
call vimtap#Is(@", "foobarbazfornow\nfoobarbarfoo\n", "deleted 3-char text")

call vimtest#SaveOut()
call vimtest#Quit()
