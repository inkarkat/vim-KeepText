" Test specifying a range pre-extending the command range with wrong direction.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(1)

call vimtap#err#Throws('No lines to keep', '13,21KeepRange /^#   space-indented/,/^Erat/', 'Error when pattern prepends the range')

call vimtest#SaveOut()
call vimtest#Quit()
