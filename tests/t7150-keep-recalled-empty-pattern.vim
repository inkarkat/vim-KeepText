" Test keeping recalled pattern text at various locations in a line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(1)

call vimtap#err#Errors('No pattern defined yet', '3normal \kk?', 'trying recall without previous query gives error')

call vimtest#SaveOut()
call vimtest#Quit()
