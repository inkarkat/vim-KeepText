" Test keeping queried pattern text in selected lines.

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(2)

execute "20normal Vj\\kk/\\<\\u\\l\\+\\>\<CR>"
call vimtap#Is(@", " volutpat.  non tortor.  posuere nisi mollis dolor. \nporttitor nisi ac elit.  tincidunt ligula vitae nulla.\n", "deleted non-Words")

let @/ = ''
execute "4normal v4j$\"a\\kk/\\w\\+-indented\<CR>"
call vimtap#Is(@a, "This 'one line' is a comment.\nThis 'two line' is new.\n\n     line\n\t line\n", "deleted after indented first WORD")

call vimtest#SaveOut()
call vimtest#Quit()
