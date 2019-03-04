" Test keeping moved-over text and indent in a line.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(6)

7normal 2W\k$
call Assert('"', 7, "    space-indented \n", "    line", "space-indented")

8normal 2W\k$
call Assert('"', 8, "\ttab-indented \n", "\tline", "tab-indented")

9normal 2W\k$
call Assert('"', 9, "\t    softtabstop-indented \n", "\t    line", "softtabstop-indented")

call vimtest#Quit()
