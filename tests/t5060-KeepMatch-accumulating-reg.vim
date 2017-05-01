" Test keeping matches while accumulating deleted stuff in a register.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(1)

let @/ = '\<...\>'
2KeepMatch a //g
3KeepMatch A //g
4,5KeepMatch A //g
call vimtap#Is(@a, "Tuple is (, , , hehe, hihi, hoho)  .\n<> <> notyetimplemented </> </>\nThis ' line' is a comment.\nThis ' line' is .\n", "deleted global non-... text")

call vimtest#SaveOut()
call vimtest#Quit()
