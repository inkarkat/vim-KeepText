" Test keeping matches of pattern and newline in a range.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(4)

20,$KeepMatchAndNewline /^.\+\n/
call vimtap#Is(@", "\n\n", "deleted empty lines")   " Note: One additional newline because at the end of the buffer.

7,18KeepMatchAndNewline y /.*tab.*\n/
call vimtap#Is(@y, "    space-indented line\n\n#   space-indented line\n\n\n\t    //  space-indented line\n", "deleted non-tab lines")

4,5KeepMatchAndNewline x /'[^']\+'/
call vimtap#Is(@x, "This  is a comment.\nThis  is new.\n", "deleted non-quoted text")

2,3KeepMatchAndNewline /\<...\>/g
call vimtap#Is(@", "Tuple is (, , , hehe, hihi, hoho)  .\n<> <> notyetimplemented </> </>\n", "deleted non-3-char text")

call vimtest#SaveOut()
call vimtest#Quit()
