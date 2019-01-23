" Test keeping last search pattern text at multiple lines that cover closed folds.

edit input.txt
setlocal foldmethod=manual
7,10fold
11,15fold
16,19fold

call vimtest#StartTap()
call vimtap#Plan(1)

let @/ = '^\s\+\S\+'
7normal 3\kkn
call vimtap#Is(@", " line\n line\n line\n\n#   space-indented line\n#\ttab-indented line\n#\t    softtabstop-indented line\n\n\n", "deleted after indented first WORD")

call vimtest#SaveOut()
call vimtest#Quit()