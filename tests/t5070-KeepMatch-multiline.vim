" Test keeping matches that cross a single line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(3)

20,$KeepMatch /Quisque\n[^.]\+\.\s\+/
call vimtap#Is(@", "Erat volutpat. Donec non tortor. Vivamus posuere nisi mollis dolor. Nullam tincidunt ligula vitae nulla.\n\nEOF\n", "deleted Quisque sentence")

7,19KeepMatch /space-\%(.*\n.*line\)\+/
call vimtap#Is(@", "    \n\n#   \n\n\n\t    //  \n\n", "deleted space-...line text")

4KeepMatch m /\w\+\.\n\w\+/
call vimtap#Is(@m, "This 'one line' is a  'two line' is new.\n", "deleted two lines excepts words across the break")

call vimtest#SaveOut()
call vimtest#Quit()
