" Test keeping non-matches of pattern and different comment prefixes in a range.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(1)

7,18KeepMatch! /-indented/<
call vimtap#Is(@", "    -indented\t-indented\t    -indented#   -indented#\t-indented#\t    -indented\t    //  -indented\t    //\t-indented\t    //\t    -indented\n", "deleted -indented indented, #-, //-commented lines")

call vimtest#SaveOut()
call vimtest#Quit()
