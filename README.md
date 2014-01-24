sentaku
=======

Utility to make sentaku (selection, 選択(sentaku)) window with shell command.

![sentaku](http://rcmdnk.github.io/images/post/20140123_sentaku.gif)

If you give multi-word to sentaku by pipe at command line,
you can choose one of them in the sentaku window
then selected one will be returned.

Requirement:

- Bash 3.X or newer
- Zsh 4.X or newer

# Installation

On Mac, you can install scripts by [Homebrew](https://github.com/mxcl/homebrew):

    $ brew tap rcmdnk/rcmdnkpac
    $ brew install sentaku

If you have [brewall](https://github.com/rcmdnk/homebrew-brewall), add following lines to Brewfile:

    tap 'rcmdnk/rcmdnkpac'
    brew 'sentaku'

then, do:

    $ brewall install

Or if you write like:

    tapall 'rcmdnk/rcmdnkpac'

and do `brewall install`, you will have all useful scripts in
[rcmdnkpac](https://github.com/rcmdnk/homebrew-rcmdnkpac).

You can also use an install script on the web like:

    $ curl -fsSL https://raw.github.com/rcmdnk/sentaku/install/install.sh| sh

This will install scripts to `/usr/bin`
and you may be asked root password.

If you want to install other directory, do like:

    $ curl -fsSL https://raw.github.com/rcmdnk/sentaku/install/install.sh|  prefix=~/usr/local/ sh

Or, simply download scripts and set where you like.

# Usage

## Standalone

Use with pipe at command line.
If you run sentaku alone, nothing happens.

Give any words to sentaku by pipe.
The default separator is `$IFS`.

If you want to use different separator,
use `-s <sep>` option.

In cas there any directory/file names which have spaces, use line break as a separator, i.e.:

    $ ls | sentaku -s $'\n'

If you want to use input file instead of pipe,
use `sentaku -F <file>`.


Other options and key operations at sentaku window are::

    Usage: sentaku [-HNladnh] [-f <file>] [-s <sep>]
    
    Arguments:
       -f <file>  Set iput file (default: ${SENTAKU_INPUT_FILE:-$_SENTAKU_INPUT_FILE})
       -F <file>  Set iput file (default: ${SENTAKU_INPUT_FILE:-$_SENTAKU_INPUT_FILE})
                  and use the list in the file for sentaku window instead of pipe's input.
       -s <sep>   Set separtor (default: ${SENTAKU_SEPARATOR:-$_SENTAKU_SEPARATOR})
                  If <sep> is \"line\", \$'\\n' is set as a separator.
       -H         Header is shown at sentaku window.
       -N         No nubmers are shown.
       -l         Show last words instead of starting words for longer lines.
       -a         Align input list (set selected one to the first).
       -d         Enable Delete at sentaku window.
       -m         Execute main function even if it is not after pipe.
                  (e.g. "-m -f <file>" == "-F <file>")
       -p         Push words to the file.
       -n         Don't run functions, to just source this file
       -h         Print this HELP and exit
    
    Key operation at sentaku window:
       n(any number) Set number. Multi digit can be used (13, 320, etc...).
                     Used/reset by other key.
       j/k        Up/Down (if n is given, n-th up/n-th down).
       ^U/^D      Half page down/Half page down.
       ^B/^F      Page up/Page down.
       gg/G       Go to top/bottom. (If n is given, move to n-th candidate.)
       d          Delete current candidate. (in case you use input file.)
       s          Show detail of current candidate.
       q/Esc      Quit.
       Ener/Space Select and Quit.

Example: [ex_pipe.sh](https://github.com/rcmdnk/sentaku/blob/master/bin/ex_pipe.sh)

## Use as a library

You can use sentaku as a library for your shell script.

At sentaku window, all normal keys are assigned to functions like:

* a-z: `_sf_a ()` ~ `_sf_z ()`
* A-Z: `_sf_A ()` ~ `_sf_z ()`
* 0-9: `_sf_0 ()` ~ `_sf_9 ()`

In addition following keys are assigned:

* Enter/Space: `_sf_select ()`
* Esc: `_sf_quit ()`

And `C-D`/`C-F`/`C-U`/`C-B` are assigned to move up down as described in the help.

Following functions have default methods:

* `_sf_j ()`/`_sf_k ()`/`_sf_g ()`/`_sf_G ()`/`_sf_d ()`/`_sf_s ()`/`_sf_q ()`

And others are just set like `_sf_a () { :;}` (do nothing).

If you simply add new key operation, make a script like:

``` sh
$!/usr/bin/env bash
. sentaku -n
_sf_a () {
  echo "You pushed a!"
}
_sf_main "$@"
```

First, load `sentaku` with `-n` option, which don't execute functions here.

Then, add your functions.

In the last, call `_sf_main` function with arguments (`$@`).

Save this script as `my_sentaku.sh`, then you can use it as same as
original sentaku command.
In addition, you can see `You pushed a!` when you push `a`.

More examples can be found below.

### Simple examples to use like snippet

The easiest examples are:

* [ex_source_bash.sh](https://github.com/rcmdnk/sentaku/blob/master/bin/ex_source_bash.sh)
* [ex_source_zsh.sh](https://github.com/rcmdnk/sentaku/blob/master/bin/ex_source_zsh.sh)

They are example to use pre-defined list file (`$HOME/.my_input`),
and select one from it.

The separator is `$'\x07'` (BELL), therefore you can store even sentences in the list file (can be used as a snippet application).

These two are examples for Bash and Zsh, respectively.
(only the shebang is different.)

### Example: Explorer

* [ex_explorer.sh](https://github.com/rcmdnk/sentaku/blob/master/bin/ex_explorer.sh)

It starts from current directory, show all files/directories.
If you choose directory, the window goes to the chosen directory.

At sentaku window:

* `s`: Show details (ls -l)
* `d`: Delete selected file/directory
* `l`: Open file with `less`
* `e`: Open file with $EDITOR (or `vim`)
* `Enter`/`Space`: Move the directly
* `q`/`Esc`: Quit

#### Tips

The original `_sf_select` function, which is executed when you push `Enter` or `Space`, is defined as:

``` sh
_sf_select () { # {{{
  _s_break=1
} # }}}
```

If `_s_break` flag is 1, it breaks key operation and goes to the end.

In this script, this function is redefined like:

``` sh
_sf_select () {
  cd ${_s_inputs[$_s_current_n]}
  ...
   _sf_printall
}
```

It does `cd` and something, and the last, 
it calls `_sf_printall` function, which prints a header and items again.
And it does not set `_s_break` flag,
therefore it stays in key operation (sentaku window).

If you want to break with any key, you can change `_s_break` flag in 
corresponding function.

### Example: menu program

* [ex_menu.sh](https://github.com/rcmdnk/sentaku/blob/master/bin/ex_menu.sh)

For the first window, you can choose:

* Keybaord Input
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

#### Tips

In this script, new sentaku instance is made in the function (at `more`).

To load sentaku in sentaku functions, do like

    . sentaku -n -c

`-c` option avoid to execute some functions which should not call
twice in the same process.

### Example: command game

* [ex_slime.sh](https://github.com/rcmdnk/sentaku/blob/master/bin/ex_slime.sh)

Usage:

* ./ex_slime.sh # Japanese
* ./ex_slime.sh -e # English


* Demo:

[![slime](http://rcmdnk.github.io/images/post/20140123_slime.jpg)](http://asciinema.org/a/7340)

# License

The MIT License (MIT)

Copyright (c) 2014 rcmdnk

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/rcmdnk/sentaku/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

