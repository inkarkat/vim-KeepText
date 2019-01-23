" Test keeping matches of pattern and comment with indent in a line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(2)

15,20KeepMatch a /\w\+-indented/<g
call vimtap#Is(@a, "\n line\n line\n line\n\nErat volutpat. Donec non tortor. Vivamus posuere nisi mollis dolor. Quisque\n", "deleted except indent and \"*-indented\"")

11,13KeepMatch /line$/<g
call vimtap#Is(@", "space-indented \ntab-indented \nsofttabstop-indented \n", "deleted except indent and \"line\" at the end")

call vimtest#SaveOut()
call vimtest#Quit()
