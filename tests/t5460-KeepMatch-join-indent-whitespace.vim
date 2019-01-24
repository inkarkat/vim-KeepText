" Test keeping matches of pattern with preceding whitespace and indent in a line.
" Tests that the preceding whitespace is removed when joining with the indent.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(3)

16,19KeepMatchAndNewline /\sline$/<
call vimtap#Is(@", "\t    //  space-indented\n\t    //\ttab-indented\n\t    //\t    softtabstop-indented\n\n", "deleted except indent, last word and its preceding space with comment prefix //")

11,13KeepMatchAndNewline /\sline$/<
call vimtap#Is(@", "#   space-indented\n#\ttab-indented\n#\t    softtabstop-indented\n", "deleted except indent, last word and its preceding space with comment prefix #")

7,9KeepMatchAndNewline /\sline$/<
call vimtap#Is(@", "    space-indented\n\ttab-indented\n\t    softtabstop-indented\n", "deleted except indent, last word and its preceding space")


call vimtest#SaveOut()
call vimtest#Quit()
