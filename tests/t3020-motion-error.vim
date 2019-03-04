" Test errors in moved-over text inside selection.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(4)

let v:errmsg = ''
21normal \zke
call vimtap#Is(v:errmsg, 'Nothing selected', 'Error when no selection made yet')

let v:errmsg = ''
execute "4normal! 2wvi'\<Esc>"
5normal 2W\zki'
call vimtap#Is(v:errmsg, 'Motion is outside selection', 'Error when no selection made yet')

let v:errmsg = ''
execute "20normal! )v)h\<Esc>"
20normal \zk)
call vimtap#Is(v:errmsg, 'Motion is outside selection', 'Error when no selection made yet')

let v:errmsg = ''
execute "20normal! )v)h\<Esc>"
20normal 2)\zke
call vimtap#Is(v:errmsg, 'Motion is outside selection', 'Error when no selection made yet')

call vimtest#SaveOut()
call vimtest#Quit()
