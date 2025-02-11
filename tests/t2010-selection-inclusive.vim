" Test keeping inclusive selections at various locations in the buffer.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

edit input.txt
set selection=inclusive
call vimtest#StartTap()
call vimtap#Plan(4)

2normal 3Wv2Elg\k2
call vimtap#Is(line('$'), 1, 'only current line kept')
call vimtap#Is(getline('.'), 'bar, baz, ', 'bar, baz kept')
call vimtap#Like(getreg('"'), '^\[default text\]\n.*\n\nEOF\n$', "entire remaining buffer deleted")

edit!
2normal "rV5}g\k
call AssertDeletedText('r', "[default text]\n\nEOF\n", "first and last sentence kept")

call vimtest#SaveOut()
call vimtest#Quit()
