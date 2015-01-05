#!/usr/bin/env bash

## Description {{{
#
# Utility to make sentaku (selection) window with shell command.
#
# Usage: sentaku [-HNladnh] [-f <file>] [-s <sep>]
#
SENTAKU_VERSION=v0.2.11
SENTAKU_DATE="05/Jan/2015"
#
# }}}

## License {{{
#
#The MIT License (MIT)
#
#Copyright (c) 2014 rcmdnk
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of
#this software and associated documentation files (the "Software"), to deal in
#the Software without restriction, including without limitation the rights to
#use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
#the Software, and to permit persons to whom the Software is furnished to do so,
#subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
#FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
#COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
#IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
#CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# }}}

# Default variables # {{{
_SENTAKU_INPUT_FILE=${_SENTAKU_INPUT_FILE:-$HOME/.sentaku_input}
_SENTAKU_SEPARATOR=${_SENTAKU_SEPARATOR:-$IFS}
_SENTAKU_MAX=${_SENTAKU_MAX:-20}
_SENTAKU_NOHEADER=${_SENTAKU_NOHEADER:-0}
_SENTAKU_NONUMBER=${_SENTAKU_NONUMBER:-0}
_SENTAKU_SHOWLAST=${_SENTAKU_SHOWLAST:-0}
_SENTAKU_CHILD=${_SENTAKU_CHILD:-0}
# 0: AND (ignore case), 1: AND (case sensitive), 2: starts with (ignore case), 3: starts with (case sensitive)
_SENTAKU_SEARCH_OPT=${_SENTAKU_SEARCH_OPT:-0}
_SENTAKU_KEYMODE=${_SENTAKU_KEYMODE:-0}
_SENTAKU_DEBUG=${_SENTAKU_DEBUG:-0}
# }}}

_sf_initialize () { # {{{
  # Set variables
  _s_file="${SENTAKU_INPUT_FILE:-$_SENTAKU_INPUT_FILE}"
  _s_use_file=0
  _s_s="${SENTAKU_SEPARATOR:-$_SENTAKU_SEPARATOR}"
  # If a separator is normal IFS, use space for file write out.
  # note: $' \t\n' should not be surrounded by '"'.
  if [ "$_s_s" = $' \t\n' ];then
    _s_s_push=" "
  else
    _s_s_push="$_s_s"
  fi
  _s_inputs=()
  _s_n=0
  _s_max=${SENTAKU_MAX:-$_SENTAKU_MAX}
  _s_header=""
  _s_noheader=${SENTAKU_NOHEADER:-$_SENTAKU_NOHEADER}
  _s_nonumber=${SENTAKU_NONUMBER:-$_SENTAKU_NONUMBER}
  _s_showlast=${SENTAKU_SHOWLAST:-$_SENTAKU_SHOWLAST}
  _s_search_opt=${SENTAKU_SEARCH_OPT:-$_SENTAKU_SEARCH_OPT}
  _s_keymode=${SENTAKU_KEYMODE:-$_SENTAKU_KEYMODE}
  _s_debug=${SENTAKU_DEBUG:-$_SENTAKU_DEBUG}
  _s_show=""
  _s_lines=0
  _s_cols=0
  _s_max_show=0
  _s_stdin=0
  _s_align=0
  _s_delete=0
  _s_continue=0
  _s_noshow=0
  _s_normal_echo=${_s_normal_echo:-1}

  _s_is_print=1

  _s_ext_row=0
  _s_current_n=-1
  _s_n_offset=0
  _s_g=0
  _s_n_move=-1
  _s_visual=-1
  _s_v_selected=()
  _s_break=0
  _s_search=""
  _s_search_words=""
  _s_pre_inputs_n=0
  local i
  for((i=0; i<1000;i++));do
    eval "_s_pre_inputs_$i=()"
  done
  _s_read=""
  _s_zsh_ksharrays=0
  _s_stty=""

  _s_ret=0

  # Help
  _s_help=${_s_help:-"
Usage: sentaku [-HNladnh] [-f <file>] [-s <sep>]

Arguments:
  -f <file>  Set iput file (default: ${SENTAKU_INPUT_FILE:-$_SENTAKU_INPUT_FILE})
  -F <file>  Set iput file (default: ${SENTAKU_INPUT_FILE:-$_SENTAKU_INPUT_FILE})
             and use the list in the file for sentaku window instead of pipe's input.
  -s <sep>   Set separtor (default: ${SENTAKU_SEPARATOR:-$_SENTAKU_SEPARATOR})
             If <sep> is \"line\", \$'\\n' is set as a separator.
  -H         Force to show a header at sentaku window.
  -N         No nubmers are shown.
  -l         Show last words instead of starting words for longer lines.
  -a         Align input list (set selected one to the first).
  -m         Execute main function even if it is not after pipe.
                 (e.g. -m -f <file> == -F <file>)
  -r <n>     Return nth value directly.
  -p         Push words to the file.
  -E         Use Emacs mode
  -V         Use Vmacs mode
  -c         Load functions as a child process in other sentaku process.
  -n         Don't run functions, to just source this file
  -v         Show version
  -h         Print this HELP and exit

Key operation at sentaku window
  Common for all:
    C-p/C-n  Up/Down.
    C-u/C-d  Half page down/Half page down.
    C-b/C-f  Page up/Page down.
    M-v/C-v  Page up/Page down.
    C-a/C-e  Go to the beggining/end.
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
    Ener     Select and Quit.

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
"}

  # Lines and columns at beginning
  _s_lines=$(tput lines)
  _s_cols=$(tput cols)

  # Fix array for zsh
  if [ "x$ZSH_VERSION" != "x" ];then
    if ! setopt|grep -q ksharrays;then
      _s_zsh_ksharrays=1
      setopt ksharrays
    fi
  fi

  # Check std input
  [ ! -t 0 ] && _s_stdin=1

  # User initialization
  _sf_initialize_user
} # }}}

_sf_initialize_user () { # {{{
  :
} # }}}

_sf_finalize () { # {{{
  if [ $_s_ret -eq 0 ] && [ $_s_current_n -ge 0 ];then
    # Execution for selected value
    _sf_execute

    # Align values
    if [ "$_s_search" != "" ];then
      local val="${_s_inputs[$_s_current_n]}"
      _s_inputs=("${_s_pre_inputs_0[@]}")
      _s_n=${#_s_inputs[@]}
      _s_current_n=0
      for((i=0; i<_s_n; i++));do
        if [ "$val" = "${_s_inputs[$i]}" ];then
          _s_current_n=$i
          break
        fi
      done
      _s_search=""
    fi
    [ $_s_align -eq 1 -a $_s_stdin -eq 0 ] && _sf_align_values $_s_current_n 0
  fi

  if [ "$_SENTAKU_CHILD" -eq 0 -a "$_s_noshow" -eq 0 ];then
    # Show cursor
    tput cnorm >/dev/tty 2>/dev/null || tput vs >/dev/tty 2>/dev/null

    # Enable echo input
    if [ $_s_stdin -eq 0 ];then
      if [ "$_s_stty" != "" ];then
        stty $_s_stty
        # followings are for fixing problems of previous commands...
        stty echo
        stty -raw
      fi
    fi
  fi

  # Release variables
  unset _s_file
  unset _s_use_file
  unset _s_s
  unset _s_s_push
  unset _s_inputs
  unset _s_n
  unset _s_max
  unset _s_header
  unset _s_noheader
  unset _s_nonumber
  unset _s_showlast
  unset _s_search_opt
  unset _s_keymode
  unset _s_debug
  unset _s_show
  unset _s_lines
  unset _s_cols
  unset _s_max_show
  unset _s_stdin
  unset _s_align
  unset _s_delete
  unset _s_continue
  unset _s_noshow
  unset _s_normal_echo

  unset _s_is_print

  unset _s_ext_row
  unset _s_current_n
  unset _s_n_offset
  unset _s_g
  unset _s_n_move
  unset _s_visual
  unset _s_v_selected
  unset _s_break
  unset _s_search
  unset _s_search_words
  unset _s_pre_inputs_n
  local i
  for((i=0; i<1000;i++));do
    eval "unset _s_pre_inputs_$i"
  done
  unset _s_read

  unset _s_help

  [ "x$_s_zsh_ksharrays" != "x" ] && [ $_s_zsh_ksharrays -eq 1 ] && unsetopt ksharrays
  unset _s_zsh_ksharrays

  unset _s_is_noexec
  unset _s_is_help
  unset _s_is_file
  unset _s_is_main
  unset _s_is_push
  unset _s_stty

  _sf_finalize_user

  local ret=$_s_ret
  unset _s_ret
  return $ret
} # }}}

_sf_finalize_user () { # {{{
  :
} # }}}

_sf_execute () { # {{{
  if [ $_s_visual -ne -1 ];then
    local is_first=1
    local i
    for((i=0; i<_s_n; i++));do
      if [ ${_s_v_selected[$i]} -eq 1 ];then
        if [ $is_first -eq 1 ];then
          printf "%s" "${_s_inputs[$i]}"
          is_first=0
        else
          printf "$_s_s%s" "${_s_inputs[$i]}"
        fi
      fi
    done
  else
    printf "%s" "${_s_inputs[$_s_current_n]}"
  fi
} # }}}

_sf_hide () { # {{{
  if [ "$_SENTAKU_CHILD" -eq 0 -a "$_s_noshow" -eq 0 ];then
    if [ $_s_stdin -eq 0 ];then
      # Save current stty
      _s_stty=$(stty -g)

      # Hide any input
      #stty raw
      stty -echo
    fi

    # Hide cursor
    tput civis >/dev/tty 2>/dev/null || tput vi >/dev/tty 2>/dev/null

    # Save current display
    tput smcup >/dev/tty 2>/dev/null || tput ti >/dev/tty 2>/dev/null

    _s_normal_echo=0
  fi
} # }}}

_sf_clear () { # {{{
  if [ "$_SENTAKU_CHILD" -eq 0 -a "$_s_noshow" -eq 0 ];then
    _sf_echo_debug "sf_clear execute\n"
    # clear after selection
    clear >/dev/tty

    # Restore display
    tput rmcup >/dev/tty 2>/dev/null || tput te >/dev/tty 2>/dev/null

    _s_normal_echo=1
  fi
} # }}}

_sf_nth () { # {{{
  if [ "$1" -eq 1 ];then
    echo 1st
  elif [ "$1" -eq 2 ];then
    echo 2nd
  elif [ "$1" -eq 3 ];then
    echo 3rd
  else
    echo "${1}th"
  fi
} # }}}

_sf_read () { # {{{
  local orig_ifs=$IFS
  IFS=
  if [ "x$ZSH_VERSION" != "x" ];then
    read -sk 1 _s_read </dev/tty
  else
    read -sn 1 _s_read </dev/tty
  fi
  IFS=$orig_ifs
} # }}}

_sf_wait () { # {{{
  _sf_read
} # }}}

_sf_yn () { # {{{
  local message="$*"
  while : ;do
    clear >/dev/tty
    echo "$message [y/n]: " >/dev/tty
    _sf_read
    if [ "$_s_read" = "y" ];then
      return 0
    elif [ "$_s_read" = "n" ];then
      _sf_quit
      return 1
    fi
  done
} # }}}

_sf_check_args () { # {{{
  # Get arguments
  _s_continue=0
  while [ $# -gt 0 ];do
    case $1 in
      "-f"|"-F" ) # Use file
        _s_file=$2
        _s_use_file=1
        if [ "$_s_file" = "" ];then
          echo "ERROR: empty input was given with -i" >/dev/tty
          return 1
        fi
        shift
        ;;
      "-s" ) # Set separator
        _s_s=$2
        if [ "$_s_s" = "line" ];then
          _s_s=$'\n'
        fi
        if [ "$_s_s" = $' \t\n' ];then
          _s_s_push=" "
        else
          _s_s_push="$_s_s"
        fi
        shift
        ;;
      "-H" ) _s_noheader=0;;
      "-N" ) _s_nonumber=1;;
      "-l" ) _s_showlast=1;;
      "-a" ) _s_align=1;;
      "-m" ) ;;
      "-r" )
        if expr "$2" : '[0-9]*' > /dev/null;then
          _s_current_n=$2
          shift
        else
          echo "-r option requires a number" >/dev/tty
          return 1
        fi
        ;;
      "-p" )
        shift
        _sf_push "$@"
        return $?
        ;;
      "-N" ) _s_nonumber=1;;
      "-E" ) _s_keymode=1;;
      "-V" ) _s_keymode=0;;
      "-c" ) ;;
      "-n" ) ;;
      "-v" ) echo "$(basename "$0") $SENTAKU_VERSION $SENTAKU_DATE" >/dev/tty; return 0;;
      "-h" )
        echo "$_s_help"|${PAGER:-less} >/dev/tty
        return 0
        ;;
      * )
        echo "$(basename "$0") $1: unknown argument
Check \"$(basename "$0") -h\" for further information" >/dev/tty
        return 1
        ;;
    esac
    shift
  done
  _s_continue=1
  return 0
} # }}}

_sf_get_values_wrapper () { # {{{ _sf_get_values_wrapper [<is_stdin> [<is_check>]]
  _sf_get_values "$1" "$2"
  _sf_setview
} # }}}

_sf_get_values () { # {{{ _sf_get_values [<is_stdin> [<is_check>]]
  local stdin=$_s_stdin
  local check=1
  if [ "$1" != "" ];then
    stdin=$1
  fi
  if [ "$2" != "" ];then
    check=$2
  fi
  # Get values
  touch "$_s_file"
  local orig_ifs=$IFS
  IFS="$_s_s"
  if [ "$stdin" -eq 0 -o "$_s_use_file" -eq 1 ];then
    _s_inputs=($(cat "$_s_file"))
  else
    _s_inputs=($(cat -))
  fi
  IFS=$orig_ifs
  if [ "x$ZSH_VERSION" != "x" ];then
    # Fix array for ZSH
    # Zsh's array adds additional empty value to array if IFS is in the end of file.
    if [ ${#_s_inputs[@]} -gt 0 ];then
      local last="${_s_inputs[$((${#_s_inputs[@]}-1))]}"
      if [ "${#last}" -eq 0 ];then
        _s_inputs=(${_s_inputs[0,$((${#_s_inputs[@]}-2))]})
      fi
    fi
  fi
  _s_n=${#_s_inputs[@]}

  if [ "$check" -eq 1 -a "$_s_n" -eq 0 ];then
    if [ "$stdin" -eq 0 -o "$_s_use_file" -eq 1 ];then
      _sf_echo "No value in $_s_file\n"
    else
      _sf_echo "No value in stdin\n"
    fi
    _s_ret=1
  else
    for((i=0; i<_s_n; i++));do
      _s_v_selected[$i]=0
    done
  fi
  _s_ret=0
} # }}}

_sf_align_values () { # {{{ _sf_align_values [<n> [<is_get>]]
  local n=${1:-$_s_current_n}
  local is_get=${2:-1}
  if ! expr "$n" : '[0-9]*' >/dev/null || [ "$n" -ge "$_s_n" ];then
    _sf_echo "$n is not valid for _sf_align_values\n"
    return 1
  fi
  local v="${_s_inputs[$n]}"
  printf "%s$_s_s_push" "$v" > "$_s_file"
  local i=0
  for ((i=0; i<_s_n && i<_s_max; i++));do
    if [ "${_s_inputs[$i]}" != "$v" ];then
      printf "%s$_s_s_push" "${_s_inputs[$i]}" >> "$_s_file"
    fi
  done
  if [ "$is_get" -eq 1 ];then
    _sf_get_values_wrapper
  fi
} # }}}

_sf_delete () { # {{{
  echo -n > "$_s_file"
  local i
  local old_current_n=$_s_current_n
  for ((i=0; i<_s_n; i++));do
    if [ $_s_visual -ne -1 -a ${_s_v_selected[$i]} -eq 1 ] ||\
       [ "$_s_visual" -eq -1 -a "$i" -eq "$old_current_n" ];then
      if [ "$i" -lt "$old_current_n" ];then
        ((_s_current_n--))
      fi
      continue
    fi
    printf "%s$_s_s_push" "${_s_inputs[$i]}" >> "$_s_file"
  done
  _sf_get_values_wrapper
} # }}}

_sf_remove () { # {{{
  local inputs
  inputs=()
  local i
  local old_current_n=$_s_current_n
  for ((i=0; i<_s_n; i++));do
    if [ "$_s_visual" -ne -1 -a "${_s_v_selected[$i]}" -eq 1 ] ||\
       [ "$_s_visual" -eq -1 -a "$i" -eq "$old_current_n" ];then
      if [ "$i" -lt "$old_current_n" ];then
        ((_s_current_n--))
      fi
      continue
    fi
    inputs[${#inputs[@]}]="${_s_inputs[$i]}"
  done
  _s_inputs=("${inputs[@]}")
  _s_n=${#_s_inputs[@]}
  for((i=0; i<_s_n; i++));do
    _s_v_selected[$i]=0
  done
} # }}}

_sf_rm_del () { # {{{
  local old_current_n=$_s_current_n
  if [ $_s_delete -eq 0 ] || [ $_s_stdin -eq 1 ];then
    _sf_remove
  else
    _sf_delete
  fi
  if [ $_s_n -eq 0 ];then
    _sf_echo "There are no remained entries\n"
    _s_ret=1
  fi
  if [ $_s_ret -ne 0 ];then
    _sf_quit $_s_ret
    return
  fi
  if [ "$_s_current_n" -ge "$_s_n" ];then
    _s_current_n=$((_s_n-1))
  fi
  if [ $_s_current_n -lt $_s_n_offset ];then
    _s_n_offset=$_s_current_n
  fi
  local n_move
  if [ $((_s_n)) -lt $((_s_lines-_s_ext_row+_s_n_offset)) ];then
    local n_move=$((_s_lines-_s_ext_row+_s_n_offset-_s_n))
    if [ $n_move -gt $_s_n_offset ];then
      n_move=$_s_n_offset
    fi
    _s_n_offset=$((_s_n_offset-n_move))
  fi
  _s_visual=-1
  for((i=0; i<_s_n; i++));do
    _s_v_selected[$i]=0
  done
  _s_is_print=1
} # }}}

_sf_show () { # _sf_show [<is_selected>] [<n_show>] {{{
  local is_selected=${1:-0}
  local n_show=${2:-$_s_cols}
  if [ "${#_s_show}" -gt "$n_show" ];then
    if [ $_s_showlast -eq 0 ];then
      if [ "x$ZSH_VERSION" != "x" ];then
        _s_show="${_s_show[0,$((n_show-1))]}" # need for zsh version < 5
      else
        _s_show="${_s_show: 0: $n_show}"
      fi
    else
      if [ "x$ZSH_VERSION" != "x" ];then
        _s_show="${_s_show[$((${#_s_show}-n_show)),-1]}"
      else
        _s_show="${_s_show: $((${#_s_show}-n_show))}"
      fi
    fi
  else
    _s_show=$(printf "%-${n_show}s" "${_s_show}")
  fi

  # Color search words
  if [ "$_s_search_words" != "" ];then
    local negative=""
    if [ "$is_selected" -eq 1 ];then
      negative=";7"
    fi
    if [ "$_s_search_opt" -le 1 ];then
      if [ "$_s_search_opt" -eq 0 ];then
        local ic="i"
      else
        local ic=""
      fi
      local words=(${_s_search_words})
      local w
      for w in "${words[@]}";do
        _s_show=$(echo $_s_show|perl -pe "s|($w)|\e[31${negative}m\1\e[0${negative}m|g$ic")
      done
    else
      if [ "$_s_search_opt" -eq 2 ];then
        local ic="i"
      else
        local ic=""
      fi
      w="${_s_search_words}"
      _s_show=$(echo "$_s_show"|perl -pe "s|($w)|\e[31${negative}m\1\e[0${negative}m|g$ic")
    fi
  fi
} # }}}

_sf_printline () { # useage: _sf_printline is_selected n_line n_input {{{
  if [ $# -lt 3 ];then
    _sf_echo "_sf_printline needs 3 arguments (is_selected, n_line, n_input), exit\n"
    _sf_quit 1
    return
  fi
  local is_selected=$1
  local n_line=$2
  local n_input=$3

  # Change line breaks to \n (to be shown), and remove the last line break
  _s_show="$(echo "${_s_inputs[$n_input]}"|awk -F\n -v ORS="\\\\\\\\n" '{print}' |sed 's|\\\\n$||')"

  tput cup "$n_line" 0 >/dev/tty
  if [ ${_s_v_selected[$n_input]} -eq 1 ];then
    printf "\e[36m" >/dev/tty
  fi
  if [ "$is_selected" -eq 1 ];then
    printf "\e[7m" >/dev/tty
  fi
  local n_show=$_s_cols
  local num=""
  if [ $_s_nonumber -eq 0 ];then
    local nmax=$((_s_n-1))
    local num_width=${#nmax}
    n_show=$((_s_cols-num_width-2))
    num=$(printf "%${num_width}d: " "$n_input")
  fi
  _sf_show "$is_selected" "$n_show"
  printf "%s\e[m" "$num$_s_show" >/dev/tty
  tput cup "$n_line" 0 >/dev/tty
} # }}}

_sf_print_current_line () { # print current line {{{
  local cursor_r=$((_s_current_n-_s_n_offset+_s_ext_row))
  _sf_printline 1 $cursor_r $_s_current_n
} # }}}

_sf_printall () { # usage: _sf_printall [not force] {{{
  # if any argument is given, check if echoed or not.
  if [ $# -ge 1 -a $_s_is_print -eq 0 ];then
    return
  fi

  local lines=$_s_lines
  local cols=$_s_cols
  _s_lines=$(tput lines)
  _s_cols=$(tput cols)

  _sf_setview

  if [ "$lines" -ne "$_s_lines" -o "$cols" -ne "$_s_cols" ];then
    _s_current_n=0
    _s_n_offset=0
  fi

  clear >/dev/tty

  # Header
  _sf_print "${_s_header}\n"

  local i=0
  for ((i=0; i<_s_max_show; i++));do
    if ((i+_s_n_offset == _s_current_n));then
      _sf_printline 1 $((i+_s_ext_row)) $((i+_s_n_offset))
    else
      _sf_printline 0 $((i+_s_ext_row)) $((i+_s_n_offset))
    fi
  done
  _s_is_print=0
} # }}}

_sf_print () { # {{{
  printf "%b" "$*" >/dev/tty
} # }}}

_sf_echo () { # {{{
  if [ $_s_noshow -eq 1 ];then
    :
  elif [ $_s_normal_echo -eq 1 ];then
    _sf_print "$*"
  else
    clear >/dev/tty
    _sf_print "$*"
    _s_is_print=1
    _sf_wait
  fi
} # }}}

_sf_echo_debug () { # {{{
  if [ "$_s_debug" = "" ];then
    # Temporarily use default value for debug_echo before initialization.
    _s_debug=$_SENTAKU_DEBUG
  fi
  if [ "$_s_debug" -gt 0 ];then
    _sf_echo "$@"
  fi
} # }}}

_sf_echo_printall () { # {{{
  _sf_echo "$@"
  _sf_printall
} # }}}

_sf_set_header () { # {{{
  _s_header=""
  if [ "$_s_noheader" = 1 -o "$_s_lines" -lt 10 ];then
    _s_header="\e[43;30m$_s_n values in total\e[0m "
    return
  fi
  if [ $_s_delete -eq 1 ];then
    local delete_key="d(delete), "
  else
    local delete_key=""
  fi
  if [ $_s_keymode -eq 0 ];then
    if [ "$_s_cols" -ge 67 ];then
      _s_header=" $_s_n values in total
 [n]j(n-down), [n]k(n-up), gg(top), G(bottom), [n]gg/G, (go to n)
 ^D(Half page down), ^U(Half page up), ^F(Page down), ^B(Page Up)
 ${delete_key}/(search), Enter/Space(select), q(quit)\n"
    elif [ "$_s_cols" -ge 40 ];then
      _s_header=" $_s_n values in total
 vimike updown, e.g)j:down, k:up, gg/G
 ${delete_key}Enter/Space(select), q(quit)\n"
    fi
  else
    if [ "$_s_cols" -ge 50 ];then
      _s_header=" $_s_n values in total
 C-n(down), C-j(up), C-v(Page down), M-v(Page up)
 ${delete_key}Enter(select), C-x(quit)
 Other normal keys start an incremental search\n"
    fi
  fi
}  # }}}

_sf_setview () { # {{{
  _sf_set_header
  _s_header="${_s_header}${_s_search}"
  _s_ext_row=$(echo $(printf "${_s_header}\n"|wc -l))

  _s_max_show=$_s_n
  if [ $_s_n -gt $((_s_lines-_s_ext_row)) ];then
    _s_max_show=$((_s_lines-_s_ext_row))
  fi
} # }}}

_sf_n_down () { # The line goes Down. (Increase the line number) {{{
  [ $_s_n_move -le 0 ] && _s_n_move=1
  local all=0
  local old_current_n=$_s_current_n
  local old_cursor_r=$((_s_current_n-_s_n_offset+_s_ext_row))
  _s_current_n=$((_s_current_n+_s_n_move))
  [ $_s_current_n -ge $_s_n ] && _s_n_move=-1 && _s_current_n=$((_s_n-1))
  [ $_s_current_n -eq $old_current_n ] && return
  if [ $((_s_current_n-_s_max_show+1)) -gt $_s_n_offset ];then
    _s_n_offset=$((_s_current_n-_s_max_show+1))
    all=1
  fi
  if [ $all -eq 1 ];then
    _s_is_print=1
  elif [ $_s_visual -lt 0 ];then
    _sf_printline 0 $old_cursor_r $old_current_n
    _sf_print_current_line
  fi
  if [ $_s_visual -ge 0 ];then
    local tmp_r=$old_cursor_r
    local tmp_n=$old_current_n
    while [ $tmp_n -lt $_s_current_n ];do
      if [ $tmp_n -lt $_s_visual ];then
        _s_v_selected[$tmp_n]=0
      else
        _s_v_selected[$tmp_n]=1
      fi
      [ $all -eq 1 ] || _sf_printline 0 $tmp_r $tmp_n
      ((tmp_r++));((tmp_n++))
    done
    _s_v_selected[$_s_current_n]=1
    [ $all -eq 1 ] || _sf_print_current_line
  fi
  _s_g=0
  _s_n_move=-1
} # }}}

_sf_n_up () { # The line goes up. (Decrease the line Number!) {{{
  [ $_s_n_move -le 0 ] && _s_n_move=1
  local all=0
  local old_current_n=$_s_current_n
  local old_cursor_r=$((_s_current_n-_s_n_offset+_s_ext_row))
  _s_current_n=$((_s_current_n-_s_n_move))
  [ $_s_current_n -lt 0 ] && _s_current_n=0
  [ $_s_current_n -eq $old_current_n ] && _s_n_move=-1 && return
  if [ $_s_current_n -lt $_s_n_offset ];then
    _s_n_offset=$_s_current_n
    all=1
  fi
  if [ $all -eq 1 ];then
    _s_is_print=1
  elif [ $_s_visual -lt 0 ];then
    _sf_printline 0 $old_cursor_r $old_current_n
    _sf_print_current_line
  fi
  if [ $_s_visual -ge 0 ];then
    local tmp_r=$old_cursor_r
    local tmp_n=$old_current_n
    while [ $tmp_n -gt $_s_current_n ];do
      if [ $tmp_n -gt $_s_visual ];then
        _s_v_selected[$tmp_n]=0
      else
        _s_v_selected[$tmp_n]=1
      fi
      [ $all -eq 1 ] || _sf_printline 0 $tmp_r $tmp_n
      ((tmp_r--));((tmp_n--))
    done
    _s_v_selected[$_s_current_n]=1
    [ $all -eq 1 ] || _sf_print_current_line
  fi
  _s_g=0
  _s_n_move=-1
} # }}}

_sf_item_move_up () { # {{{ Move the item up
  [ $_s_current_n -eq 0 ] && return

  [ $_s_n_move -le 0 ] && _s_n_move=1

  local replace=$((_s_current_n-_s_n_move))
  [ $replace -lt 0 ] && replace=0

  local v_current=${_s_inputs[$_s_current_n]}
  local v_replace=${_s_inputs[$replace]}
  _s_inputs[$_s_current_n]=$v_replace
  _s_inputs[$replace]=$v_current
  [ $_s_stdin -eq 0 ] && _sf_align_values 0 0
  _sf_printall
  _sf_n_up
} # }}}

_sf_item_move_down () { # {{{ Move the item down
  [ $_s_current_n -eq $((_s_n-1)) ] && return

  [ $_s_n_move -le 0 ] && _s_n_move=1

  local replace=$((_s_current_n+_s_n_move))
  [ $replace -gt $((_s_n-1)) ] && replace=$((_s_n-1))

  local v_current=${_s_inputs[$_s_current_n]}
  local v_replace=${_s_inputs[$replace]}
  _s_inputs[$_s_current_n]=$v_replace
  _s_inputs[$replace]=$v_current
  [ $_s_stdin -eq 0 ] && _sf_align_values 0 0
  _sf_printall
  _sf_n_down
} # }}}

_sf_quit () { # {{{
  [ $# -gt 0 ] && _s_ret=$1
  _s_current_n=-1
  _s_break=1
} # }}}

_sf_select () { # {{{
  _s_break=1
} # }}}

_sf_search () { # {{{
  local first_char=$1
  if [ "$_s_search" = "" ];then
    _s_pre_inputs_0=("${_s_inputs[@]}")
    _s_pre_inputs_n=0
    _s_search="Search:"
  fi

  if [ "$first_char" = "" ];then
    _sf_printall
  fi
  while : ;do
    local del=0
    if [ "$first_char" != "" ];then
      _s_search_words="$_s_search_words$first_char"
      first_char=""
    else
      _sf_read
      local r=$_s_read
      case $r in
        $'\E' ) # Esc
          _sf_read
          local r2=$_s_read
          if [ "$r2" = "v" ];then # M-v
            _s_n_move=$((_s_max_show)); _sf_n_up
            continue
          elif [ "$r2" = "[" ];then
            _sf_read
            local r3=$_s_read
            if [ "$r3" = "A" ];then # cursor up
              _sf_n_up
              continue
            elif [ "$r3" = "B" ];then # cursor down
              _sf_n_down
              continue
            fi
          fi
          if [ $_s_n -eq 0 ] || [ $_s_keymode -eq 1 ];then
            _s_inputs=("${_s_pre_inputs_0[@]}")
            _s_n=${#_s_inputs[@]}
            _s_search=""
            _s_search_words=""
            _sf_reset
          fi
          return
          ;;
        $'\ch') # ^H
          if [ "$_s_search_words" = "" ];then
            _s_search=""
            _s_search_words=""
            _sf_reset
            return
          fi
          if [ "x$ZSH_VERSION" != "x" ];then
            # need for zsh version < 5
            _s_search_words="${_s_search_words[0,$((${#_s_search_words}-2))]}"
          else
            _s_search_words="${_s_search_words: 0: ((${#_s_search_words}-1))}"
          fi
          ((_s_pre_inputs_n--))
          eval "_s_inputs=(\"\${_s_pre_inputs_$((_s_pre_inputs_n))[@]}\")"
          _s_n=${#_s_inputs[@]}
          del=1
          ;;
        $'\cu') # ^U
          _s_search_words=""
          _s_pre_inputs_n=0
          ;;
        " " )
          # Space to start visual
          if [ "$_s_search_words" = "" ] || echo "$_s_search_words"|grep -q " $";then
            if [ ${_s_v_selected[$_s_current_n]} -eq 1 ];then
              _s_v_selected[$_s_current_n]=0
            else
              _s_v_selected[$_s_current_n]=1
            fi
            _s_visual=-2
            _sf_print_current_line
          else
            _s_search_words="$_s_search_words$_s_read"
          fi
          continue
          ;;
        ""|$'\n' )
          _sf_enter
          return
          ;;
        $'\ca' ) _sf_c_a; continue;;
        $'\cb' ) _sf_c_b; continue;;
        $'\cc' ) _sf_c_c; continue;;
        $'\cd' ) _sf_c_d; continue;;
        $'\ce' ) _sf_c_e; continue;;
        $'\cf' ) _sf_c_f; continue;;
        $'\cg' ) _sf_c_g; continue;;
        $'\ch' ) _sf_c_h; continue;;
        $'\ci' ) _sf_c_i; continue;;
        $'\cj' ) _sf_c_j; continue;;
        $'\ck' ) _sf_c_k; continue;;
        $'\cl' ) _sf_c_l; continue;;
        $'\cm' ) _sf_c_m; continue;;
        $'\cn' ) _sf_c_n; continue;;
        $'\co' ) _sf_c_o; continue;;
        $'\cp' ) _sf_c_p; continue;;
        $'\cr' ) _sf_c_r; continue;;
        $'\cs' ) _sf_c_s; continue;;
        $'\ct' ) _sf_c_t; continue;;
        $'\cu' ) _sf_c_u; continue;;
        $'\cv' ) _sf_c_v; continue;;
        $'\cw' ) _sf_c_w; continue;;
        $'\cx' ) _sf_c_x; continue;;
        $'\cy' ) _sf_c_y; continue;;
        $'\cz' ) _sf_c_z; continue;;

        *)_s_search_words="$_s_search_words$_s_read";;
      esac
    fi

    _s_search="Search: \e[31m$_s_search_words\e[0m"

    if [ "$_s_search_words" = "" ];then
      _s_inputs=("${_s_pre_inputs_0[@]}")
      _s_n=${#_s_inputs[@]}
    elif [ $del -eq 1 ];then
      :
    else
      local inputs
      inputs=()
      local n_before=${#_s_inputs[@]}
      local i
      for ((i=0; i<_s_n; i++));do
        _sf_search_check "${_s_inputs[$i]}"
        if [ $? -eq 0 ];then
          inputs=("${inputs[@]}" "${_s_inputs[$i]}")
        fi
      done
      _s_inputs=("${inputs[@]}")
      _s_n=${#_s_inputs[@]}
      ((_s_pre_inputs_n++))
      eval "_s_pre_inputs_${_s_pre_inputs_n}=(\"\${_s_inputs[@]}\")"
    fi

    _sf_reset
  done
} # }}}

_sf_search_check () { # {{{
  local input="$1"
  if [ "$_s_search_opt" -le 1 ];then
    if [ "$_s_search_opt" -eq 0 ];then
      local ic="-i"
    else
      local ic=""
    fi
    local words=(${_s_search_words})
    local w
    for w in "${words[@]}";do
      if ! echo "${input}"| grep $ic -q "${w}";then
        return 1
      fi
    done
  else
    if [ "$_s_search_opt" -eq 2 ];then
      local ic="-i"
    else
      local ic=""
    fi
    if ! echo "${input}"| grep $ic -q "^${_s_search_words}";then
      return 1
    fi
  fi
  return 0
} # }}}

_sf_reset () { # {{{
  _s_current_n=0
  _s_n_offset=0
  _s_g=0
  _s_n_move=-1
  _s_visual=-1
  for((i=0; i<_s_n; i++));do
    _s_v_selected[$i]=0
  done
  tput cup "$_s_ext_row" 0 >/dev/tty
  _sf_printall
} # }}}

_sf_visual_start () { # {{{
  if [ $_s_visual -ge 0 ];then
    _s_visual=-2
  else
    _s_v_selected[$_s_current_n]=1
    _s_visual=$_s_current_n
    _sf_print_current_line
  fi
} # }}}

_sf_gG () { # {{{
  _s_n_move=$((_s_n_move-_s_current_n))
  if [ $_s_n_move -eq 0 ];then
    return
  fi
  if [ $_s_n_move -lt 0 ];then
    _s_n_move=$((0-_s_n_move))
    _sf_n_up
  else
    _sf_n_down
  fi
} # }}}

_sf_n_move_inc () { # {{{
  local n=${1:-"0"}
  [ $_s_n_move -gt 0 ] && _s_n_move="$_s_n_move""$n" || _s_n_move=$n
} # }}}

# function for 0-9 {{{
_sf_0 () { # {{{
  _sf_n_move_inc 0
} # }}}
_sf_1 () { # {{{
  _sf_n_move_inc 1
} # }}}
_sf_2 () { # {{{
  _sf_n_move_inc 2
} # }}}
_sf_3 () { # {{{
  _sf_n_move_inc 3
} # }}}
_sf_4 () { # {{{
  _sf_n_move_inc 4
} # }}}
_sf_5 () { # {{{
  _sf_n_move_inc 5
} # }}}
_sf_6 () { # {{{
  _sf_n_move_inc 6
} # }}}
_sf_7 () { # {{{
  _sf_n_move_inc 7
} # }}}
_sf_8 () { # {{{
  _sf_n_move_inc 8
} # }}}
_sf_9 () { # {{{
  _sf_n_move_inc 9
} # }}}
# }}} function for 0-9

# function for a-z {{{
_sf_a () { # {{{
  :
} # }}}
_sf_b () { # {{{
  :
} # }}}
_sf_c () { # {{{
  :
} # }}}
_sf_d () { # {{{
  _sf_rm_del
} # }}}
_sf_e () { # {{{
  :
} # }}}
_sf_f () { # {{{
  :
} # }}}
_sf_g () { # {{{
  if [ $_s_g -eq 0 ];then
    _s_g=1
    return
  fi
  if [ "$_s_n_move" -lt 0 ];then
    _s_n_move=0
  fi
  _sf_gG
} # }}}
_sf_h () { # {{{
  :
} # }}}
_sf_i () { # {{{
  :
} # }}}
_sf_j () { # {{{
  _sf_n_down
} # }}}
_sf_k () { # {{{
  _sf_n_up
} # }}}
_sf_l () { # {{{
  :
} # }}}
_sf_m () { # {{{
  :
} # }}}
_sf_n () { # {{{
  :
} # }}}
_sf_o () { # {{{
  :
} # }}}
_sf_p () { # {{{
  :
} # }}}
_sf_q () { # {{{
  _sf_quit
} # }}}
_sf_r () { # {{{
  :
} # }}}
_sf_s () { # {{{
  _sf_echo "$(_sf_nth $((_s_current_n))) value:

${_s_inputs[$_s_current_n]}\n"
} # }}}
_sf_t () { # {{{
  :
} # }}}
_sf_u () { # {{{
  :
} # }}}
_sf_v () { # {{{
  _sf_visual_start
} # }}}
_sf_w () { # {{{
  :
} # }}}
_sf_x () { # {{{
  :
} # }}}
_sf_y () { # {{{
  :
} # }}}
_sf_z () { # {{{
  :
} # }}}
# function for a-z }}}

# function for A-Z {{{
_sf_A () { # {{{
  :
} # }}}
_sf_B () { # {{{
  :
} # }}}
_sf_C () { # {{{
  :
} # }}}
_sf_D () { # {{{
  :
} # }}}
_sf_E () { # {{{
  :
} # }}}
_sf_F () { # {{{
  :
} # }}}
_sf_G () { # {{{
  if [ $_s_n_move -lt 0 ];then
    _s_n_move=$_s_n
  fi
  _sf_gG
} # }}}
_sf_H () { # {{{
  :
} # }}}
_sf_I () { # {{{
  :
} # }}}
_sf_J () { # {{{
  :
} # }}}
_sf_K () { # {{{
  :
} # }}}
_sf_L () { # {{{
  :
} # }}}
_sf_M () { # {{{
  :
} # }}}
_sf_N () { # {{{
  :
} # }}}
_sf_O () { # {{{
  :
} # }}}
_sf_P () { # {{{
  :
} # }}}
_sf_Q () { # {{{
  :
} # }}}
_sf_R () { # {{{
  :
} # }}}
_sf_S () { # {{{
  :
} # }}}
_sf_T () { # {{{
  :
} # }}}
_sf_U () { # {{{
  :
} # }}}
_sf_V () { # {{{
  :
} # }}}
_sf_W () { # {{{
  :
} # }}}
_sf_X () { # {{{
  :
} # }}}
_sf_Y () { # {{{
  :
} # }}}
_sf_Z () { # {{{
  :
} # }}}

# function for <C-a>-<C-Z>, <C-Space> {{{
_sf_c_a () { # {{{
  _s_n_move=0
  _sf_gG
  #for((i=0; i<$_s_n; i++));do
  #  _s_visual=-2
  #  _s_v_selected[$i]=1
  #done
  #_s_is_print=1
} # }}}
_sf_c_b () { # {{{
  _s_n_move=$((_s_max_show))
  _sf_n_up
} # }}}
_sf_c_c () { # {{{
  :
} # }}}
_sf_c_d () { # {{{
  _s_n_move=$((_s_max_show/2))
  _sf_n_down
} # }}}
_sf_c_e () { # {{{
  _s_n_move=$_s_n
  _sf_gG
} # }}}
_sf_c_f () { # {{{
  _s_n_move=$((_s_max_show))
  _sf_n_down
} # }}}
_sf_c_g () { # {{{
  :
} # }}}
_sf_c_h () { # {{{
  :
} # }}}
_sf_c_i () { # {{{
  _sf_item_move_up
} # }}}
_sf_c_j () { # {{{
  :
} # }}}
_sf_c_k () { # {{{
  :
} # }}}
_sf_c_l () { # {{{
  :
} # }}}
_sf_c_m () { # {{{
  :
} # }}}
_sf_c_n () { # {{{
  _sf_n_down
} # }}}
_sf_c_o () { # {{{
  _sf_item_move_down
} # }}}
_sf_c_p () { # {{{
  _sf_n_up
} # }}}
_sf_c_q () { # {{{
  :
} # }}}
_sf_c_r () { # {{{
  _s_is_print=1
  :
} # }}}
_sf_c_s () { # {{{
  _sf_visual_start
} # }}}
_sf_c_t () { # {{{
  :
} # }}}
_sf_c_u () { # {{{
  _s_n_move=$((_s_max_show/2))
  _sf_n_up
} # }}}
_sf_c_v () { # {{{
  _s_n_move=$((_s_max_show))
  _sf_n_down
} # }}}
_sf_c_w () { # {{{
  :
} # }}}
_sf_c_x () { # {{{
  _sf_quit
} # }}}
_sf_c_y () { # {{{
  :
} # }}}
_sf_c_z () { # {{{
  :
} # }}}
# function for C-a-C-Z }}}

_sf_esc () { # {{{
  _sf_read
  local r2=$_s_read
  if [ "$r2" = "v" ];then # M-v
    _s_n_move=$((_s_max_show)); _sf_n_up
    return
  elif [ "$r2" = "[" ];then
    _sf_read
    local r3=$_s_read
    if [ "$r3" = "A" ];then # cursor up
      _sf_n_up
      return
    elif [ "$r3" = "B" ];then # cursor down
      _sf_n_down
      return
    fi
  fi
  if [ $_s_visual -ne -1 ];then
    _s_visual=-1
    for((i=0; i<_s_n; i++));do
      _s_v_selected[$i]=0
    done
    _s_is_print=1
  fi
  if [ "$_s_search" != "" ];then
    _s_inputs=("${_s_pre_inputs_0[@]}")
    _s_n=${#_s_inputs[@]}
    _s_search=""
    _s_search_words=""
    _sf_reset
  fi
} # }}}

_sf_space () { # {{{
  # Space to start visual
  if [ "$_s_search_words" = "" ] || echo "$_s_search_words"|grep -q " $";then
    if [ ${_s_v_selected[$_s_current_n]} -eq 1 ];then
      _s_v_selected[$_s_current_n]=0
    else
      _s_v_selected[$_s_current_n]=1
    fi
    _s_visual=-2
    _sf_print_current_line
  fi
} # }}}

_sf_enter () { # {{{
  _sf_select
} # }}}

_sf_slash () { # {{{
  _sf_search
} # }}}

_sf_push () { # {{{

  _sf_echo_debug "_sf_push start\n"

  # Set input
  local input="$*"
  shift $#
  if [ $_s_stdin -eq 1 ];then
    input=$(cat -)
  fi

  # Ignore blank
  if [ "$input" = "" ];then
    return 1
  fi

  # Renew values
  _sf_get_values_wrapper 0 0
  local orig_ifs=$IFS
  IFS="$_s_s_push"
  _s_inputs=("$input"${_s_s_push}"${_s_inputs[@]}")
  IFS=$orig_ifs
  _s_n=${#_s_inputs[@]}
  _sf_align_values 0 0

  _sf_echo "$input is stored in $_s_file\n"
} # }}}

_sf_main () { # {{{

  # Set trap
  trap "_sf_clear;_s_stdin=0;_s_ret=1;_sf_finalize;exit" HUP INT QUIT ABRT SEGV TERM
  #trap "_sf_printall; echo >/dev/stdin" WINCH

  # Initializatoin
  _sf_initialize

  # Get arguments
  _sf_check_args "$@"
  _s_ret=$?
  if [ $_s_continue -eq 0 ];then
    _sf_finalize
    return $?
  fi

  # Get values
  _sf_get_values_wrapper
  _s_ret=$?
  if [ $_s_ret -ne 0 ];then
    _sf_finalize
    return $?
  fi

  # Return nth
  if [ $_s_current_n -ge 0 ];then
    _sf_finalize
    return $?
  fi

  # Hide displays
  _sf_hide

  # Initialize values
  _sf_reset

  while : ;do
    _sf_printall 1
    _sf_read
    local r=$_s_read
    case $r in
      # Use common functions of C-*, Esc, Space and Enter for both vim/emacs modes.
      $'\ca' ) _sf_c_a;;
      $'\cb' ) _sf_c_b;;
      $'\cc' ) _sf_c_c;;
      $'\cd' ) _sf_c_d;;
      $'\ce' ) _sf_c_e;;
      $'\cf' ) _sf_c_f;;
      $'\cg' ) _sf_c_g;;
      $'\ch' ) _sf_c_h;;
      $'\ci' ) _sf_c_i;;
      $'\cj' ) _sf_c_j;;
      $'\ck' ) _sf_c_k;;
      $'\cl' ) _sf_c_l;;
      $'\cm' ) _sf_c_m;;
      $'\cn' ) _sf_c_n;;
      $'\co' ) _sf_c_o;;
      $'\cp' ) _sf_c_p;;
      $'\cr' ) _sf_c_r;;
      $'\cs' ) _sf_c_s;;
      $'\ct' ) _sf_c_t;;
      $'\cu' ) _sf_c_u;;
      $'\cv' ) _sf_c_v;;
      $'\cw' ) _sf_c_w;;
      $'\cx' ) _sf_c_x;;
      $'\cy' ) _sf_c_y;;
      $'\cz' ) _sf_c_z;;
      $'\E' ) _sf_esc;;
      " " ) _sf_space;;
      ""|$'\n' ) _sf_enter;; # Enter (Normally "" corresponds to Enter (line break before any key))

      # Differences for difference modes.
      * )
        if [ $_s_keymode -eq 0 ];then
          case $r in
            # Vim mode
            0 ) _sf_0;;
            1 ) _sf_1;;
            2 ) _sf_2;;
            3 ) _sf_3;;
            4 ) _sf_4;;
            5 ) _sf_5;;
            6 ) _sf_6;;
            7 ) _sf_7;;
            8 ) _sf_8;;
            9 ) _sf_9;;
            a ) _sf_a;;
            b ) _sf_b;;
            c ) _sf_c;;
            d ) _sf_d;;
            e ) _sf_e;;
            f ) _sf_f;;
            g ) _sf_g;;
            h ) _sf_h;;
            i ) _sf_i;;
            j ) _sf_j;;
            k ) _sf_k;;
            l ) _sf_l;;
            m ) _sf_m;;
            n ) _sf_n;;
            o ) _sf_o;;
            p ) _sf_p;;
            q ) _sf_q;;
            r ) _sf_r;;
            s ) _sf_s;;
            t ) _sf_t;;
            u ) _sf_u;;
            v ) _sf_v;;
            w ) _sf_w;;
            x ) _sf_x;;
            y ) _sf_y;;
            z ) _sf_z;;
            A ) _sf_A;;
            B ) _sf_B;;
            C ) _sf_C;;
            D ) _sf_D;;
            E ) _sf_E;;
            F ) _sf_F;;
            G ) _sf_G;;
            H ) _sf_H;;
            I ) _sf_I;;
            J ) _sf_J;;
            K ) _sf_K;;
            L ) _sf_L;;
            M ) _sf_M;;
            N ) _sf_N;;
            O ) _sf_O;;
            P ) _sf_P;;
            Q ) _sf_Q;;
            R ) _sf_R;;
            S ) _sf_S;;
            T ) _sf_T;;
            U ) _sf_U;;
            V ) _sf_V;;
            W ) _sf_W;;
            X ) _sf_X;;
            Y ) _sf_Y;;
            Z ) _sf_Z;;
            / ) _sf_slash;;
          esac
        else
          _sf_search "$r"
        fi
        ;;
    esac
    [ $_s_break -eq 1 ] && break
  done

  # Clear (Show cursor, Restore display, Enable echo input)
  _sf_clear

  # Finalization
  _sf_finalize
} # }}}

# Execution part {{{
_s_is_exec=1
_sf_check_args_first () { # {{{
  while [ $# -gt 0 ];do
    case $1 in
      "-h"|"-N"|"-m"|"-p"|"-F"|"-v" ) _s_is_exec=2;shift;;
      "-n" ) _s_is_exec=0;shift;;
      "-c" ) _SENTAKU_CHILD=1;shift;;
    * )break;;
    esac
  done
} # }}}

_sf_check_args_first "$@"

# Execute if stdin is available, or any of help/file/push is on
if [ $_s_is_exec -ne 0 ];then
  if [ -p /dev/stdin ] || [ $_s_is_exec -eq 2 ];then
    _sf_main "$@"
  fi
fi

# Clean up
unset _s_is_exec
# }}}
