" Test keeping moved-over text at various locations in the buffer.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(4)

2normal 3Wg\k2W
call vimtap#Is(line('$'), 1, 'only current line kept')
call vimtap#Is(getline('.'), 'bar, baz, ', 'bar, baz kept')
call vimtap#Like(getreg('"'), '^\[default text\]\n.*\n\nEOF\n$', "entire remaining buffer deleted")

edit!
2normal "rg\k5}
call AssertDeletedText('r', "[default text]\n\nEOF\n", "first and last sentence kept")

call vimtest#SaveOut()
call vimtest#Quit()
