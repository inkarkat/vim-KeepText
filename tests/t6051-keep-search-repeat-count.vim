" Test repeat of keeping last search pattern text with count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(3)

let @/ = '\<\w\+-indented'
7normal 3\kkn
call vimtap#Is(@", "     line\n\t line\n\t     line\n", "keep three lines")

11normal .
call vimtap#Is(@", "#    line\n#\t line\n#\t     line\n", "repeats on three lines")

16normal 2.
call vimtap#Is(@", "\t    //   line\n\t    //\t line\n", "repeat for two lines")

call vimtest#SaveOut()
call vimtest#Quit()
