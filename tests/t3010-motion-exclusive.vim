" Test keeping moved-over text inside exclusive selection.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

edit input.txt
set selection=exclusive
call vimtest#StartTap()
call vimtap#Plan(6)

execute "3normal! Wv3E\<Esc>"
3normal 2W\zke
call Assert('"', 3, "<bar>  </bar>", "<foo> notyetimplemented </foo>", "keep inner tag inside selection")

execute "20normal! )v3)\<Esc>"
20normal ))\zk)
call Assert('"', [20, 21], "Donec non tortor. Quisque\nporttitor nisi ac elit. ", "Erat volutpat. Vivamus posuere nisi mollis dolor. Nullam tincidunt ligula vitae nulla.\n", "keep sentence inside multi-line selection")

execute "7normal! V18G\<Esc>"
12normal 11|\zk3l
call Assert('"', [6, 8], "    space-indented line\n\ttab-indented line\n\t    softtabstop-indented line\n\n#   space-indented line\n#\ttandented line\n#\t    softtabstop-indented line\n\n\n\t    //  space-indented line\n\t    //\ttab-indented line\n\t    //\t    softtabstop-indented line\n", "\nb-i\n", "keep 3 letter in linewise selection")

call vimtest#SaveOut()
call vimtest#Quit()
