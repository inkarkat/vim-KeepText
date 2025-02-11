" Test when moved-over text is only partially inside selection.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(6)

let v:warningmsg = ''
execute "20normal! )v)h\<Esc>"
20normal W\zk2W
call Assert('"', 20, "non tortor. ", "Erat volutpat. Donec Vivamus posuere nisi mollis dolor. Quisque", "partial overlap at front")
call vimtap#Is(v:warningmsg, 'Only partial overlap at front; extending selection', 'Warning on partial overlap at front')

edit!
let v:warningmsg = ''
execute "20normal! )v)h\<Esc>"
20normal 4W\zk2W
call Assert('"', 20, "Donec non ", "Erat volutpat. tortor. Vivamus posuere nisi mollis dolor. Quisque", "partial overlap at back")
call vimtap#Is(v:warningmsg, 'Only partial overlap at back; extending selection', 'Warning on partial overlap at back')

call vimtest#Quit()
