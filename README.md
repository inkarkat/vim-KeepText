KEEP TEXT
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

It is easy to delete some text: By {motion}, visual selection, with
:substitute. The opposite isn't so easy: You'd have to yank to a temporary
register, delete the remainder, and paste; you cannot simply invert a
selection; with :substitute, the match has to be captured and referenced in
the replacement.
This plugin adds commands for normal, visual, and command-line mode that let
you easily specify text (by {motion}, selection, [range], or {pattern}), and
then removes everything else in the command's scope (line, buffer, last
selection, [range]). It basically offers delete commands that operate on an
inverted target. Like normal delete, the removed text is properly stored in a
register.

USAGE
------------------------------------------------------------------------------

    ["x]<Leader>k{motion}   Delete any text in the line(s) covered by {motion}
                            except for the text that {motion} moves over itself,
                            and any indent (including a potential comment prefix).
                            Register x contains the deleted text (and the indent,
                            too).
    {Visual}["x]<Leader>k   Delete any text in the selected line(s) except the
                            selected text itself, and any indent / comment prefix.

    ["x]<Leader>kkn         Within the current line / [N] / selected lines, delete
    {Visual}["x]<Leader>kkn any text that does not match the last search pattern,
                            and also keep any indent (including a potential
                            comment prefix).
    ["x]<Leader>kkN         Same sa <Leader>kkn, but query whether to keep each
    {Visual}["x]<Leader>kkN match.

    ["x]g<Leader>k{motion}  Delete any text in the entire buffer except for the
                            text that {motion} moves over itself.
                            Register x contains the deleted text.
    {Visual}["x]g<Leader>k  Delete any text in the entire buffer except the
                            selected text itself.

    ["x]<Leader>zk{motion}  Delete any text in the last selection except for the
                            text that {motion} moves over itself. {motion} must be
                            (at least partially) inside the selection.
                            Register x contains the deleted text.

    :[range]KeepRange [{register}] {range}
                            Delete any lines of the buffer / within [range] except
                            those that are covered by {range} into the unnamed
                            register / [{register}].
    :[range]KeepRange! [{register}] {range}
                            Delete any lines of the buffer / within [range] that
                            are covered by {range} into the unnamed register /
                            [{register}].

    :[range]KeepMatch [{register}] /{pattern}/[flags]
                            Within the current line / [range], delete any text
                            that does not match {pattern} into the unnamed
                            register / [{register}]. Only match(es) are kept.
                            Pass the special [<] flag to also keep any indent
                            (including a potential comment prefix), both in the
                            line and as part of the deleted text.
    :[range]KeepMatch [{register}] /{pattern}/{string}/[flags]
                            Like above, but keep {string} (which can refer to the
                            match via &, \1, etc.)

    :[range]KeepMatch! [{register}] /{pattern}/[flags]
                            Within the current line / [range], delete any text
                            that matches {pattern} into the unnamed
                            register / [{register}]. Only text that does not match
                            is kept. This is like
                                :[range]substitute/{pattern}//[flags]
                            but it stores the deleted text in a register.
    :[range]KeepMatch! [{register}] /{pattern}/{string}/[flags]
                            Like above, but store {string} (which can refer to the
                            match via &, \1, etc.) in a register.

    :[range]KeepMatchAndNewline [{register}] /{pattern}/[flags]
                            Within the current line / [range], delete any text
                            that does not match {pattern} into the unnamed
                            register / [{register}]. Only match(es) and newline
                            characters are kept; i.e. in contrast to :KeepMatch,
                            this variant does not join lines if the newline is not
                            included in {pattern}.
                            Pass the special [<] flag to also keep any indent
                            (including a potential comment prefix), both in the
                            line and as part of the deleted text.
                            This command is similar to
                                :[range]global/^/KeepMatch ...
                            but with correct register contents. Note: When
                            executed on a single line, it's the same as
                            :KeepMatch.
    :[range]KeepMatchAndNewline [{register}] /{pattern}/{string}/[flags]
                            Like above, but keep {string} (which can refer to the
                            match via &, \1, etc.)
    :[range]KeepMatchAndNewline! [{register}] /{pattern}/[flags]
    :[range]KeepMatchAndNewline! [{register}] /{pattern}/{string}/[flags]
                            Within the current line / [range], delete any text
                            that matches {pattern} and newlines into the unnamed
                            register / [{register}]. Only text that does not match
                            and newlines are kept. This is like
                                :[range]substitute/{pattern}//[flags]
                            but it stores the deleted text in a register.

### EXAMPLE

We want to keep just the quoted text: Hello, world!
```
He said: "Hello, world!" and then left.
```

Instead of yi"0\_Dp or yi"Vp, we can now simply do &lt;Leader&gt;ki", or vi"&lt;Leader&gt;k.
Instead of

    :substitute/.*"\(.*\)".*/\1/

use:

    :KeepMatch/"\zs.*\ze"/

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-KeepText
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim KeepText*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.037 or
  higher.
- repeat.vim ([vimscript #2136](http://www.vim.org/scripts/script.php?script_id=2136)) plugin (optional)
- visualrepeat.vim ([vimscript #3848](http://www.vim.org/scripts/script.php?script_id=3848)) plugin (optional)

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

If you want to use different mappings, map your keys to the
&lt;Plug&gt;(KeepText...) mapping targets _before_ sourcing the script
(e.g. in your vimrc):

    nmap <Leader>k <Plug>(KeepTextLineOperator)
    xmap <Leader>k <Plug>(KeepTextLineVisual)
    nmap <Leader>K <Plug>(KeepTextBufferOperator)
    xmap <Leader>K <Plug>(KeepTextBufferVisual)
    nmap <Leader>z <Plug>(KeepTextSelectionOperator)

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-KeepText/issues or email (address below).

HISTORY
------------------------------------------------------------------------------

##### GOAL
First published version.

##### 0.01    01-Feb-2013
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2013-2019 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
