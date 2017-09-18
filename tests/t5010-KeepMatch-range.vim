" Test keeping matches of pattern in a range.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(3)

20,$KeepMatch /^.\+\n/
call vimtap#Is(@", "\n\n", "deleted empty lines")   " Note: One additional newline because at the end of the buffer.

7,18KeepMatch y /.*tab.*\n/
call vimtap#Is(@y, "    space-indented line\n\n#   space-indented line\n\n\n\t    //  space-indented line\n", "deleted non-tab lines")

4,5KeepMatch x /'[^']\+'/
call vimtap#Is(@x, "This  is a comment.\nThis  is new.\n", "deleted non-quoted text")

call vimtest#SaveOut()
call vimtest#Quit()
