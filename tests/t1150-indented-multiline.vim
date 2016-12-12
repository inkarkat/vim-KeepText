" Test keeping moved-over text and indent across multiple lines.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(6)

7normal 2W\k2E
call Assert('"', [7, 8], "    space-indented  line\n", "    line\n\ttab-indented", "space-indented")

11normal 2W\k3E
call Assert('"', [11, 12], "#   space-indented  line\n", "#   line\n#\ttab-indented", "comment + indented")

16normal 3W\k3E
call Assert('"', [16, 17], "\t    //  space-indented  line\n", "\t    //  line\n\t    //\ttab-indented", "indent + comment + indented")

call vimtest#Quit()
