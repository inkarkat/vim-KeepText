" Test keeping moved-over text inside blockwise selection.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

edit input.txt
call vimtest#StartTap()
call vimtap#Plan(8)

execute "16normal! 2w\<C-v>2j$\<Esc>"
17normal 4w\zke
call Assert('"', [16, 18], "space-indented line\ntab- line\n    softtabstop-indented line", "\t    //  indented\n\t    //\t\n\t    //\t", "keep inside zaggy blockwise selection")

execute "11normal! 3w\<C-v>e2j\<Esc>"
12normal 3w\zke
call Assert('"', [11, 13], "indented l\nb-\n  softtabs", "#   space-indentedine\n#	ta line\n#	  top-indented line", "keep partially inside blockwise selection, extended")

execute "20normal! )\<C-v>)hj\<Esc>"
21normal w\zk2e
call Assert('"', [20, 21], "pat. Donec non tortor. \n elit. Nullam ti", "Erat volutnisi acVivamus posuere nisi mollis dolor. Quisque\nporttitor ncidunt ligula vitae nulla.", "keep partially inside blockwise selection, front extended")

execute "2normal! w\<C-v>3j2e\<Esc>"
3normal 2W\zke
call Assert('"', [2, 4], "is (foo, bar, baz, hehe, hihi, hoho) for now.\n<bar>  </bar> </foo>\none line' is a comment.\ntwo line' is new.", "Tuple notyetimplemented\n<foo> \nThis '", "keep partially inside blockwise selection, zaggily extended")

call vimtest#Quit()
