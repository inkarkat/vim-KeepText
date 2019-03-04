" Test keeping last search pattern text at multiple lines.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(2)

let @/ = '\<\u\l\+\>'
20normal 2\kkn
call vimtap#Is(@", " volutpat.  non tortor.  posuere nisi mollis dolor. \nporttitor nisi ac elit.  tincidunt ligula vitae nulla.\n", "deleted non-Words")

let @/ = '\%(^\s\+\)\@<=\S\+'
4normal "a5\kkn
call vimtap#Is(@a, "This 'one line' is a comment.\nThis 'two line' is new.\n\n     line\n\t line\n", "deleted after indented first WORD")

call vimtest#SaveOut()
call vimtest#Quit()
