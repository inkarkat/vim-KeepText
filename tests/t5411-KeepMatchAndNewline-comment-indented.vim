" Test keeping matches of pattern and comment with indent and newline in a line.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(2)

15,20KeepMatchAndNewline a /\w\+-indented/<g
call vimtap#Is(@a, "\n\t    //   line\n\t    //\t line\n\t    //\t     line\n\nErat volutpat. Donec non tortor. Vivamus posuere nisi mollis dolor. Quisque\n", "deleted except indent and \"*-indented\"")

11,13KeepMatchAndNewline /line$/<g
call vimtap#Is(@", "#   space-indented \n#\ttab-indented \n#\t    softtabstop-indented \n", "deleted except indent and \"line\" at the end")

call vimtest#SaveOut()
call vimtest#Quit()
