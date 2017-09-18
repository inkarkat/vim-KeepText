" Test keeping matches that cross a single line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(2)

20,$KeepMatch /Quisque\n[^.]\+\.\s\+/
call vimtap#Is(@", "Erat volutpat. Donec non tortor. Vivamus posuere nisi mollis dolor. Nullam tincidunt ligula vitae nulla.\n\nEOF\n", "deleted Quisque sentence")

4,19KeepMatch /space-\%(.*\n.*line\)\+/
call vimtap#Is(@", "This 'one line' is a comment.\nThis 'two line' is new.\n\n    \n\n#   \n\n\n\t    //  \n\n", "deleted space-...line text")

call vimtest#SaveOut()
call vimtest#Quit()
