" Test keeping last search pattern text in selected lines.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(2)

let @/ = '\<\u\l\+\>'
20normal Vj\kkn
call vimtap#Is(@", " volutpat.  non tortor.  posuere nisi mollis dolor. \nporttitor nisi ac elit.  tincidunt ligula vitae nulla.\n", "deleted non-Words")

let @/ = '\w\+-indented'
4normal v4j$"a\kkn
call vimtap#Is(@a, "This 'one line' is a comment.\nThis 'two line' is new.\n\n line\n line\n", "deleted after indented first WORD")

call vimtest#SaveOut()
call vimtest#Quit()
