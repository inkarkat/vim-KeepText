" Test keeping moved-over text including indent across multiple lines.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(8)

9normal l\ke
call Assert('"', 9, "\t-indented line\n", "    softtabstop", "include part of indent")

11normal \ke
call Assert('"', 11, "-indented line\n", "#   space", "include comment and indent")

16normal l\k2e
call Assert('"', 16, "\t-indented line\n", "    //  space", "include part of indent, comment and indent")

18normal wl\ke
call Assert('"', 18, "\t    /-indented line\n", "/\t    softtabstop", "include part of comment and indent")

call vimtest#Quit()
