" Test keeping everything of a whole-line motion.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(1)

execute "5normal \"r\\k)"
call AssertDeletedText('r', "", "everything kept")

call vimtest#SaveOut()
call vimtest#Quit()
