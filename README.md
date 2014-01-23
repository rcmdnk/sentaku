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
use `sentaku -f <file>`.

Other options are:

    Usage: sentaku [-HNladnh] [-f <file>] [-s <sep>]
    
    Arguments:
       -f <file>  Set iput file (default: ~/.sentaku_input)
       -s <sep>   Set separtor (default:
    )
                  If <sep> is "line", $'\n' is set as a separator.
       -H         Header is shown at sentaku window
       -N         No nubmers are shown
       -l         Show last words instead of starting words for longer lines
       -a         Align input list (set selected one to the first)
       -d         Enable Delete at sentaku window
       -p         Push words to the file
       -n         Don't run functions, to just source this file
       -h         Print this HELP and exit


Example: [expipe.sh](https://github.com/rcmdnk/sentaku/blob/master/bin/ex_pipe.sh)

## Key operation at sentaku window

## Use as a library

You can use sentaku as a library for your shell script.

The easiest examples are:

* [ex_source_bash.sh](https://github.com/rcmdnk/sentaku/blob/master/bin/ex_source_bash.sh)
* [ex_source_zsh.sh](https://github.com/rcmdnk/sentaku/blob/master/bin/ex_source_zsh.sh)

They are example to use pre-defined list file (`$HOME/.my_input`),
and select one from it.

The separator is `$'\x07'` (BELL), therefore you can store even sentences in the list file (can be used as a snippet application).

These two are examples for Bash and Zsh, respectively.
(only shebang is different.)



# To do

Fix error at trap for subshell case (ex_pipe.sh case)

    stty: tcsetattr: Input/output error

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

