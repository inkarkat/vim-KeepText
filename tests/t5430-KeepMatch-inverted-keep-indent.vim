" Test keeping non-matches of pattern and indent in a line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(3)

16,18KeepMatch! /-indented/<
call vimtap#Is(@", "\t    //  -indented\t    //\t-indented\t    //\t    -indented\n", "deleted -indented //-commented lines")

11,13KeepMatch! y /-indented/<
call vimtap#Is(@y, "#   -indented#\t-indented#\t    -indented\n", "deleted -indented #-commented lines")

7,9KeepMatch! x /-indented/<
call vimtap#Is(@x, "    -indented\t-indented\t    -indented\n", "deleted -indented indented lines")

call vimtest#SaveOut()
call vimtest#Quit()
