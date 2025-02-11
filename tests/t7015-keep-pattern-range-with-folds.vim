" Test keeping queried pattern text at multiple lines that cover closed folds.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

edit input.txt
setlocal foldmethod=manual
7,10fold
11,15fold
16,19fold

call vimtest#StartTap()
call vimtap#Plan(1)

execute "9normal 3\\kk/\\w\\+-indented\<CR>"
call vimtap#Is(@", "     line\n\t line\n\t     line\n\n#    line\n#\t line\n#\t     line\n\n\n", "deleted after indented first WORD")

call vimtest#SaveOut()
call vimtest#Quit()
