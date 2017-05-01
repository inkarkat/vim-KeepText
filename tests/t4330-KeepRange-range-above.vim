" Test specifying a range pre-extending the command range.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(1)

13,21KeepRange ?^#   space-indented?,/^Erat/
call vimtap#Is(@", "porttitor nisi ac elit. Nullam tincidunt ligula vitae nulla.\n", 'deleted line')

call vimtest#SaveOut()
call vimtest#Quit()
