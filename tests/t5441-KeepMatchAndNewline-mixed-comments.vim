" Test keeping matches of pattern and different comment prefixes and newlines in a range.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(1)

7,18KeepMatchAndNewline /-indented/<
call vimtap#Is(@", "    space line\n\ttab line\n\t    softtabstop line\n\n#   space line\n#\ttab line\n#\t    softtabstop line\n\n\n\t    //  space line\n\t    //\ttab line\n\t    //\t    softtabstop line\n", "keep -indented in indented, #-, //-commented lines")

call vimtest#SaveOut()
call vimtest#Quit()
