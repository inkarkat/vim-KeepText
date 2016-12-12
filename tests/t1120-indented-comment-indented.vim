" Test keeping moved-over text and indented comment followed by indent in a line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(6)

16normal 3W\k$
call Assert('"', 16, "\t    //  space-indented \n", "\t    //  line", "space-indented")

17normal 3W\k$
call Assert('"', 17, "\t    //\ttab-indented \n", "\t    //\tline", "tab-indented")

18normal 3W\k$
call Assert('"', 18, "\t    //\t    softtabstop-indented \n", "\t    //\t    line", "softtabstop-indented")

call vimtest#Quit()
