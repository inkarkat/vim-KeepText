" Test keeping matches of pattern with newline in the buffer.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(1)

%KeepMatch /^\%(T\|\s\).*\n/
call vimtap#Is(@", "[default text]\n<foo> <bar> notyetimplemented </bar> </foo>\n\n\n#   space-indented line\n#\ttab-indented line\n#\t    softtabstop-indented line\n\n\n\nErat volutpat. Donec non tortor. Vivamus posuere nisi mollis dolor. Quisque\nporttitor nisi ac elit. Nullam tincidunt ligula vitae nulla.\n\nEOF\n", "deleted non-indented or starting with T lines")

call vimtest#SaveOut()
call vimtest#Quit()
