" Test keeping indented blockwise selections at various locations.

edit input.txt
set selection=inclusive
call vimtest#StartTap()
call vimtap#Plan(6)

execute "7normal 15|\<C-v>2e2j\\k"
call Assert('"', [7, 9], "    space-inde\n\ttab-inne\n\t    so-indented line\n", "    nted line\n    dented li\n    fttabstop", "indented block")

execute "11normal 15|\<C-v>2e2j\\k"
call Assert('"', [11, 13], "#   space-inde\n#\ttab-inne\n#\t    so-indented line\n", "#   nted line\n#   dented li\n#   fttabstop", "comment + indented block")

execute "16normal 27|\<C-v>2e2j\\k"
call Assert('"', [16, 18], "\t    //  space-inde\n\t    //\ttab-indent\n\t    //\t    softtaented line\n", "\t    //  nted line\n\t    //  ed line\n\t    //  bstop-ind", "indent + comment + indented block")

call vimtest#Quit()
