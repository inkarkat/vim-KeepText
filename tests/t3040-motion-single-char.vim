" Test when moved-over text covers only one character.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(2)

execute "3normal! vE\<Esc>"
3normal w\zkl
call Assert('"', 3, "<oo>", "f <bar> notyetimplemented </bar> </foo>", "single character keep")

call vimtest#Quit()
