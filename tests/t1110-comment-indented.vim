" Test keeping moved-over text and comment followed by indent in a line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(6)

11normal 2W\k$
call Assert('"', 11, "#   space-indented \n", "#   line", "space-indented")

12normal 2W\k$
call Assert('"', 12, "#\ttab-indented \n", "#\tline", "tab-indented")

13normal 2W\k$
call Assert('"', 13, "#\t    softtabstop-indented \n", "#\t    line", "softtabstop-indented")

call vimtest#Quit()
