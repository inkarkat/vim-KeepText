" Test keeping everything of a linewise selection.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(2)

execute "7normal V2j\"r\\k"
call AssertDeletedText('r', "", "everything kept")

execute "16normal V2j\"r\\k"
call AssertDeletedText('r', "", "everything kept")

call vimtest#SaveOut()
call vimtest#Quit()
