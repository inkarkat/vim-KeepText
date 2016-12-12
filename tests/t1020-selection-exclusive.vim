" Test keeping exclusive selections at various locations in a line.

edit input.txt
set selection=exclusive
call vimtest#StartTap()
call vimtap#Plan(4)

2normal 3Wv2W\k
call AssertDeletedText('"', "Tuple is (foo, hehe, hihi, hoho) for now.\n", "bar, baz in middle kept")

4normal 2wvi'\k
call AssertDeletedText('"', "This '' is a comment.\n", "one line as inner quote kept")

20normal $bve\k
call AssertDeletedText('"', "Erat volutpat. Donec non tortor. Vivamus posuere nisi mollis dolor. \n", "Quisque at end kept")

21normal v)"r\k
call AssertDeletedText('r', "Nullam tincidunt ligula vitae nulla.\n", "first sentence kept")

call vimtest#SaveOut()
call vimtest#Quit()
