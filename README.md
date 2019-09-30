sentaku
=======

Utility to make sentaku (selection, 選択(sentaku)) window with shell command.

![sentaku](http://rcmdnk.github.io/images/post/20140124_sentaku.gif)

If you give multi-word to sentaku by pipe at command line,
you can choose one of them in the sentaku window
then selected one will be returned.

Requirement:

- Bash 3.X or later
- Zsh 4.X or later

## Installation

### Homebrew on Mac
On Mac, you can install scripts by [Homebrew](https://github.com/mxcl/homebrew):

    $ brew tap rcmdnk/rcmdnkpac
    $ brew install sentaku

If you have [brew file](https://github.com/rcmdnk/homebrew-file), add following lines to Brewfile:

    tap 'rcmdnk/rcmdnkpac'
    brew 'sentaku'

then, do:

    $ brew file install

Or if you write like:

    tapall 'rcmdnk/rcmdnkpac'

and do `brew file install`, you will have all useful scripts in
[rcmdnkpac](https://github.com/rcmdnk/homebrew-rcmdnkpac).

Homebrew installation installs all scripts in `bin` directory including examples.


### cURL

You can also use an install script on the web like:

    $ curl -fsSL https://raw.github.com/rcmdnk/sentaku/install/install.sh| sh

This will install scripts to `/usr/bin`
and you may be asked root password.

If you want to install other directory, do like:

    $ curl -fsSL https://raw.github.com/rcmdnk/sentaku/install/install.sh|  prefix=~/usr/local/ sh

This method installs only `sentaku` and `ddv`.

### By hand

Or, simply download scripts and set where you like.

## Usage

### Standalone

Use with pipe at command line.
If you run sentaku alone, nothing happens.

Give any words to sentaku by pipe.
The default separator is `$IFS`.

If you want to use different separator,
use `-s <sep>` option.

In case there any directory/file names which have spaces, use line break as a separator, i.e.:

    $ ls | sentaku -s $'\n'

If you want to use input file instead of pipe,
use `sentaku -F <file>`.

Other options and key operations at sentaku window are:

    Usage: sentaku [-HNulapEVcCURLSnvh] [-f <file>] [-s <sep>] [-r <n>] [input variables]

    Arguments:
      -f <file>  Set input file
      -s <sep>   Set separator (default: $IFS)
                 If <sep> is \"line\", \$'\\n' is set as a separator.
      -H         Force to show a header at sentaku window.
      -N         No numbers are shown.
      -u         Use underline to show selected line, instead of highlighting.
      -l         Show last words instead of starting words for longer lines.
      -a         Align input list (set selected one to the first).
      -r <n>     Return nth value directly.
      -p         Push words to the file.
      -E         Use Emacs mode
      -V         Use Vim mode
      -c         Load functions as a child process in other sentaku process.
      -C         Show the file content at the list view
      -R         Show the file content in the right (default: right)
      -U         Show the file content under the list (default: right)
      -L         Number of lines to show the file content under the list (default: 10)
      -S         Open the file under the cursor by ${VISUAL:-less} at s
                 instead of full line of the selected one
      -n         Don't run functions, to just source this file
      -v         Show version
      -h         Print this HELP and exit

    Key operation at sentaku window
      Common for all:
        C-p/C-n  Up/Down.
        C-u/C-d  Half page down/Half page down.
        C-b/C-f  Page up/Page down.
        M-v/C-v  Page up/Page down.
        C-a/C-e  Go to the beginning/end.
        C-i/C-o  Move the item up/down.
        C-x      Quit.
        C-s      Start/Stop Visual mode (multi-selection).
        Space    Select/unselect current line for multi-selection.
                 At Emacs mode or search mode in Vim mode,
                 it selects when space is pushed twice.
        Esc      At search mode, first Esc takes it back to normal mode
                 with selected words.
                 Second Esc clear search mode.
                 Visual mode is cleared by first Esc.
        Enter    Select and Quit.

      For Vim mode:
        n(any number) Set number. Multi-digit can be used (13, 320, etc...).
                      Used/reset by other key.
        k/j      Up/Down (if n is given, n-th up/n-th down).
        gg/G     Go to top/bottom. (If n is given, move to n-th candidate.)
        d        Delete current candidate. (in case you use input file.)
        s        Show detail of current candidate.
        v        Visual mode, same as C-s
        /        Search.
        q        Quit.
        Others   Nothing happens.

      For Emacs mode:
        Others   Normal keys start an incremental search.

#### Environment Variables

Name| Description| Default
:--:|:-----------|:------:
SENTAKU_INPUT_FILE|File used when stdin is not used (overwritten by -f).|"$HOME/.sentaku_input"
SENTAKU_SEPARATOR|Separator(overwritten by -s).|$IFS
SENTAKU_MAX|Max number to be written to the file (non-stdin usage).|20
SENTAKU_NOHEADER|Don't show the header (overwritten by -H). 0: show, 1: don't show.|0 (1 for noheader)
SENTAKU_NONUMBER|Don't show the line number (overwritten by -N). 0: show, 1: don't show.|0 (1 for nonumber)
SENTAKU_SHOWLAST|Show the number at the end of the line, too (overwritten by -l). 0: don't show, 1: show.|0
SENTAKU_CONTENT_LINES|Set number of lines to show the file content under the list|10
SENTAKU_CONTENT_SHOW_UNDER|Set 1 to set default view of the file content as under the list|0
SENTAKU_CHILD|If this sentaku is child process of parent sentaku or not.|0
SENTAKU_SEARCH_OPT|Search option, 0: AND (ignore case), 1: AND (case sensitive), 2: starts with (ignore case), 3: starts with (case sensitive).|1
SENTAKU_KEYMODE|Vim Mode or Emacs Mode, 0: Vim Mode, 1: Emacs Mode (overwritten by -V/-E).| 0
SENTAKU_DEBUG|If it is 1, `_sf_echo_debug` is executed.|0

#### Vim/Emacs mode

Default mode is Vim mode, in which you can go up/down with k/j, respectively.

If you like emacs mode, you use `-E` option,
or set the value like `export SENTAKU_KEYMODE=1` in your `.bashrc`/`.zshrc`.
In this mode, `<C-n>`/`<C-p>` are used for going up/down, respectively (These keys are also available at Vim mode).
It has nice feature that you can start incremental search directly
by pushing any normal keys.

* Simple Examples:
    * [ex_pipe.sh](https://github.com/rcmdnk/sentaku/blob/master/bin/ex_pipe.sh): Example for Vim mode (Default).
    * [ex_emacs](https://github.com/rcmdnk/sentaku/blob/master/bin/ex_emacs.sh): Example for Emacs mode.

* Item Up/Down Demo

![item_up_down](http://rcmdnk.github.io/images/post/20140621_sentaku_item_updown.gif)


#### Search mode

If you push `/`, sentaku enters search mode (at Vim mode).

You can narrow the list by pushing starting characters.

Backspace (`<C-h>`) can be used to delete a character.
In addition, `<C-u>` deletes all characters.

You can select the first of the list (or the last remained one) by the Enter.

If you push `Esc` while some candidates are remained,
you can select them as select window.

When you push `Esc` again, the original list will come back.

You can set search option `SENTAKU_SEARCH_OPT`:

* 0: AND search (smart case, i.e. all lower case word search is case insensitive, otherwise case sensitive) (Default)
* 1: AND search (case sensitive)
* 2: Starts with (smart case)
* 3: Starts with(case sensitive)

* [Search Demo for Vim mode, SENTAKU_KEYMODE = 3](http://rcmdnk.github.io/images/post/20140805_vim_search.gif)

![sentaku_vim](http://rcmdnk.github.io/images/post/20140805_vim_search.gif)


* [Search Demo for Emacs mode, SENTAKU_KEYMODE = 1](http://rcmdnk.github.io/images/post/20140805_emacs_search.gif)

![sentaku_emacs](http://rcmdnk.github.io/images/post/20140805_emacs_search.gif)

#### Visual mode (multi-selection)

![sentaku_vim_multi](http://rcmdnk.github.io/images/post/20140805_vim_multi.gif)

By pushing `Ctrl-s` (or `v` (only Vim mode)),
you can start/stop to choose multi-line.

Output will be separated by `SENTAKU_SEPARATOR` (default is $IFS).

You can choose non-sequential lines.

In addition, you can toggle lines by `Space`.

![sentaku_multi](http://rcmdnk.github.io/images/post/20140926_sentaku_multi.gif)

#### Content view

![sentaku_multi](http://rcmdnk.github.io/images/post/20190930_sentakucontentview.gif)

* [sentakuでファイルの中身を選択中に表示する](http://rcmdnk.github.io/blog/2019/09/30/computer-bash-zsh-sentaku/)

### Use as a library

You can use sentaku as a library for your shell script.

At sentaku window, all normal keys are assigned to functions like:

* a-z: `_sf_a ()` ~ `_sf_z ()`
* A-Z: `_sf_A ()` ~ `_sf_z ()`
* 0-9: `_sf_0 ()` ~ `_sf_9 ()`
* Ctrl-a - Ctrl-z: `_sf_c_a ()` ~ `_sf_c_z ()`

In addition following keys are assigned:

* Enter/Space: `_sf_select ()`
* /: Start Search
* Esc: Reset Search

Following functions have default methods:

* `_sf_0 ()` ~ `_sf_9 ()`
* `_sf_d ()`/`_sf_g ()`/`_sf_j ()`/`_sf_k ()`/`_sf_q ()`/`_sf_s ()`/`_sf_v ()`/`_sf_G ()`
* `_sf_c_a ()`/`_sf_c_b ()`/`_sf_c_c ()`/`_sf_c-e ()`/`_sf_c_f ()`/`_sf_c_c_n ()`/`_sf_c_s ()`/`_sf_c_u ()`/`_sf_c_v ()`/`_sf_c_x ()`

And others are just set like `_sf_a () { :;}` (do nothing).

If you simply add new key operation, make a script like:

``` sh
#!/usr/bin/env bash
. sentaku -n
_sf_a () {
  _sf_echo "You pushed a!"
}
_sf_main "$@"
```

First, load `sentaku` with `-n` option, which don't execute functions here.

Then, add your functions.

In the last, call `_sf_main` function with arguments (`$@`).

Save this script as `my_sentaku.sh`, then you can use it as same as
original sentaku command.
In addition, you can see `You pushed a!` when you push `a`.
To show something, use `_sf_echo` instead of `echo`.

You can define functions instead of making scripts, too.

In **.bashrc** or **.zshrc**,
add

``` sh
my_sentaku () {
  (
    . sentaku -n

    _sf_a () {
      _sf_echo "You pushed a!"
    }

    _sf_main "$@"
  )
}
```

then you can use `my_sentaku` with your `_sf_a` instead of `sentaku`.

Note: Use sub shell (define function content in `()`)
because `. sentaku -n` loads a lot of functions
and it is better to avoid making current environment dirty.

More examples can be found below.

#### Simple examples to use like snippet

The easiest examples are:

* [ex_source_bash.sh](https://github.com/rcmdnk/sentaku/blob/master/bin/ex_source_bash.sh)
* [ex_source_zsh.sh](https://github.com/rcmdnk/sentaku/blob/master/bin/ex_source_zsh.sh)

They are example to use pre-defined list file (`$HOME/.my_input`),
and select one from it.

The separator is `$'\x07'` (BELL), therefore you can store even sentences in the list file (can be used as a snippet application).

These two are examples for Bash and Zsh, respectively.
(only the shebang is different.)

#### Example: Explorer

* [ex_explorer.sh](https://github.com/rcmdnk/sentaku/blob/master/bin/ex_explorer.sh)

It starts from current directory, show all files/directories.
If you choose directory, the window goes to the chosen directory.

At sentaku window:

* `s`: Show details (ls -l)
* `d`: Delete selected file/directory
* `l`: Open file with `less`
* `e`: Open file with $EDITOR (or `vim`)
* `Enter`/`Space`: Move the directly
* `q`: Quit

##### Tips

The original `_sf_select` function, which is executed when you push `Enter` or `Space`, is defined as:

``` sh
_sf_select () { # {{{
  _s_break=1
} # }}}
```

If `_s_break` flag is 1, it breaks key operation and goes to `_sf_execute ()`.
If you want to skip `_sf_execute`, call `_sf_quit` instead of `_sf_select=`.

In this script, this function is redefined like:

``` sh
_sf_select () {
  cd ${_s_inputs[$_s_current_n]}
  ...
}
```

It does `cd` to currently selected directory (`${_s_inputs[$_s_current_n]}`),

`_s_current_n` is currently selected number (same as the number in the left of the list.)
`_s_inputs` is an array which is made from the input.
Therefore, `${_s_inputs[$_s_current_n]}` is currently selected value.

And it does not set `_s_break` flag,
therefore it stays in key operation (sentaku window).

If you want to break with any key, you can change `_s_break` flag in
corresponding function.


Another point: `_sf_l` is defined as:

``` sh
_sf_l () { # {{{
  clear >/dev/tty
  less ${_s_inputs[$_s_current_n]} >/dev/tty </dev/tty
  _sf_quit
} # }}}
```

In this script, it opens selected file: `${_s_inputs[$_s_current_n]}`.

#### Example: menu program

* [ex_menu.sh](https://github.com/rcmdnk/sentaku/blob/master/bin/ex_menu.sh)

For the first window, you can choose:

* Keyboard Input
* ls
* pwd
* date
* more

If you choose `Keyboard Input`, your input will be returned.
`ls`, `pwd` and `date` return these commands results.

If you choose `more`, you will go to the second window

* echo aaa
* echo bbb
* echo ccc
* echo ddd

Each command return such `aaa`.

If you put `q` here, you will be back to the first window.

##### Tips

In this script, new sentaku instance is made in the function (at `more`).

To load sentaku in sentaku functions, do like

    . sentaku -n -c

`-c` option avoid to execute some functions which should not call
twice in the same process.

#### Example: command game

* [ex_slime.sh](https://github.com/rcmdnk/sentaku/blob/master/bin/ex_slime.sh)

Usage:

* ./ex_slime.sh # Japanese
* ./ex_slime.sh -e # English


* [Demo](http://asciinema.org/a/7340):

[![slime](http://rcmdnk.github.io/images/post/20140124_slime.jpg)](http://asciinema.org/a/7340)

#### Example: ddv (Diff Directories and open with Vim)

* [ddv](https://github.com/rcmdnk/sentaku/blob/master/bin/ddv)

Use like:

    $ ddv dir1 dir2

`ddv` makes a list of files which are in both directories, but have differences.

Use `Enter`/`Space` to open these files with `vim -d`.
Then, you can edit these files with vim diff mode.

You can remove a file from the sentaku window by `d`,
once you edited and file becomes fine or you think the file is not needed to be edited.

* [Demo](http://asciinema.org/a/7373):

[![ddv](http://rcmdnk.github.io/images/post/20140127_ddv.jpg)](http://asciinema.org/a/7373)

#### Other examples from other repositories

##### sd_cl

[rcmdnk/sd_cl](https://github.com/rcmdnk/sd_cl)

Useful functions to change directories for Bash/Zsh and GNU screen/tmux.

##### trash

[rcmdnk/trash](https://github.com/rcmdnk/trash)

Remove Command using a trash box.

##### multi_clipboard

[rcmdnk/multi_clipboard](https://github.com/rcmdnk/multi_clipboard)

Clipboard manager for GNU screen.

## References

* [シェルスクリプトで対話的な選択を出来るようにするスクリプトを作った:sentaku](http://rcmdnk.github.io/blog/2014/01/24/computer-bash-zsh/)
