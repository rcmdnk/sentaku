#!/usr/bin/env bash

# Example of explorer
. sentaku -n

_SENTAKU_SEPARATOR=$'\n'
_SENTAKU_EDITOR=""

# New variable
_s_a=0

# New help
_s_help="
Usage: ex_explorer.sh [-aHNl] [-f <file>] [-s <sep>]

Arguments:
   -a         Show hidden files/directories.
   -H         Header is shown at sentaku window.
   -N         No nubmers are shown.
   -l         Show last words instead of starting words for longer lines.
   -h         Print this HELP and exit.
"

_sf_get_values () { # {{{
  # Get variables
  local orig_ifs=$IFS
  IFS="$_s_s"
  if [ $_s_a -eq 1 ];then
    _s_inputs=($(ls -a))
  else
    _s_inputs=(".." $(ls))
  fi
  IFS=$orig_ifs
  _s_n=${#_s_inputs[@]}
} # }}}

_sf_printline () { # useage: _sf_printline is_selected n_line n_input {{{
  local show=${_s_inputs[$3]}
  tput cup $2 0 >/dev/tty
  if [ $1 -eq 1 ];then
    printf "\e[7m" >/dev/tty
  fi
  if [ -d "$show" ];then
    printf "\e[33;1m" >/dev/tty
  fi
  local n_show=$_s_cols
  local num=""
  if [ $_s_nonumber -eq 0 ];then
    n_show=$((_s_cols-5))
    num=$(printf "%3d: " $3)
  fi
  if [ ${#show} -gt $n_show ];then
    if [ $_s_showlast -eq 0 ];then
      if [ "$ZSH_NAME" = "zsh" ];then # need for zsh version < 5
        printf "$num${show[0,$((n_show-1))]}" >/dev/tty
      else
        printf "$num${show: 0: $n_show}" >/dev/tty
      fi
    else
      if [ "$ZSH_NAME" = "zsh" ];then # need for zsh version < 5
        printf "$num${show[$((${#show}-$n_show)),-1]}" >/dev/tty
      else
        printf "$num${show: $((${#show}-$n_show))}" >/dev/tty
      fi
    fi
  else
    printf "$num${show}" >/dev/tty
  fi
  printf "\e[m" >/dev/tty
  tput cup $2 0 >/dev/tty
} # }}}

_sf_execute () { # {{{
  :
} # }}}

_sf_check_args () { # {{{
  # Get arguments
  _s_continue=0
  while [ $# -gt 0 ];do
    case $1 in
      "-a" ) _s_a=1;shift;;
      "-H" ) _s_noheader=1;shift;;
      "-N" ) _s_nonumber=1;shift;;
      "-l" ) _s_showlast=1;shift;;
      "-h" )
        _sf_echo "$_s_help"
        return 0
        ;;
      * )
        _sf_echo "$_s_help"
        return 1
        ;;
    esac
  done
  _s_continue=1
  return 0
} # }}}

_sf_finalize_user () { # {{{
  unset _s_a
} # }}}

_sf_select () { # {{{
 if [ -d "${_s_inputs[$_s_current_n]}" ];then
   cd "${_s_inputs[$_s_current_n]}"
   _sf_get_values
   _sf_reset
 else
   _sf_echo "${_s_inputs[$_s_current_n]} is not a directory"
 fi
} # }}}

_sf_set_header () { # {{{
  _s_header=""
  if [ $_s_noheader != 1 -a $_s_lines -gt 10 ];then
    local curdir=$(pwd)
    if [ $((${#curdir}+1)) -gt $_s_cols ];then
      if [ "$ZSH_NAME" = "zsh" ];then
        curdir=${curdir[$((${#curdir}-${_s_cols}+1)),-1]}
      else
        curdir=${curdir: $((${#curdir}-${_s_cols}+1))}
      fi
    fi
    if [ $_s_cols -ge 66 ];then
      _s_header=" $curdir
 [n]j(n-down), [n]k(n-up), gg(top), G(bottom), [n]gg/G, (go to n),
 ^D(Half page down), ^U(Half page up), ^F(Page down), ^B(Page Up),
 s(show detail), d(delete), l(open with less), e(edit the file)
 Enter(select, move to the directory), q(quit)"
    elif [ $_s_cols -ge 42 ];then
      _s_header=" $curdir
 vim-like updown, e.g)j:down, k:up, gg/G
 s(show detail), d(delete),
 l(open with less), e(edit the file)
 Enter(move to the directory), q(quit)"
    fi
  fi
} # }}}

_sf_d () {
  clear >/dev/tty
  local yes=0
  while : ;do
    echo "Delete ${_s_inputs[$_s_current_n]}?: (y/n)"
    _sf_read
    if [ "$_s_read" = "y" ];then
      yes=1
      break
    elif [ "$_s_read" = "n" ];then
      break
    fi
  done
  if [ $yes -eq 1 ];then
    rm -rf ${_s_inputs[$_s_current_n]}
  fi
  _sf_get_values
}

_sf_s () { # {{{
  _sf_echo $(ls -l "${_s_inputs[$_s_current_n]}")
} # }}}

_sf_l () { # {{{
  clear >/dev/tty
  less ${_s_inputs[$_s_current_n]} >/dev/tty </dev/tty
} # }}}

_sf_e () { # {{{
  local e=${_SENTAKU_EDITOR:-${EDITOR}}
  e=${e:-vim}
  $e ${_s_inputs[$_s_current_n]} >/dev/tty </dev/tty
  _sf_quit
} # }}}

_sf_main "$@"

