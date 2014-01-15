#!/bin/sh

# Example to make menu program

. sentaku -n

# New variable
_s_a=0

# New help
_s_help="
Usage: ex_explorer.sh [-aHNl] [-f <file>] [-s <sep>]

Arguments:
   -a         Show
   -H         Header is shown at selection mode
   -N         No nubmers are shown
   -l         Show last words instead of starting words for longer lines
   -h         Print this HELP and exit
"

_sf_get_values () { # {{{
  # Get variables
  local inputs
  if [ $_s_a -eq 1 ];then
    _s_inputs=($(ls -a))
  else
    _s_inputs=(".." $(ls))
  fi
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
  while [ $# -gt 0 ];do
    case $1 in
      "-a" ) _s_a=1;shift;;
      "-H" ) _s_noheader=1;shift;;
      "-N" ) _s_nonumber=1;shift;;
      "-l" ) _s_showlast=1;shift;;
      "-h" )
        echo "$_s_help" >/dev/tty
        local dummy=$(_sf_read)
        return 0
        ;;
      * )
        echo "$_s_help" >/dev/tty
        local dummy=$(_sf_read)
        return 1
        ;;
    esac
  done
 return 10
} # }}}

_sf_release_more () { # {{{
  unset _s_a
} # }}}

_sf_select () { # {{{
 if [ -d ${_s_inputs[$_s_current_n]} ];then
   cd ${_s_inputs[$_s_current_n]}
   _s_current_n=0
   _s_n_offset=0
   _s_cursor_r=$_s_ext_row
   _s_g=0
   _s_n_move=0
   _sf_get_values
   _sf_printall
 else
   clear
   echo "${_s_inputs[$_s_current_n]} is not a directory" >/dev/tty
   local dummy=$(_sf_read)
   _sf_printall
 fi
} # }}}

_sf_setheader () { # {{{
  _s_header=""
  if [ $_s_noheader != 1 ];then
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
 s(show detail), d(delete), l(open with less), v(open with vim)
 Enter(select, move to the directory), q/Esc(quit)
"
    elif [ $_s_cols -ge 42 ];then
      _s_header=" $curdir
 vim-like updown, e.g)j:up, k:down, gg/G
 s(show detail), d(delete),
 l(open with less), v(open with vim)
 Enter(move to the directory), q/Esc(quit)
"
    fi
  fi
} # }}}

_sf_d () {
  clear >/dev/tty
  local yes=0
  while : ;do
    echo "Delete ${_s_inputs[$_s_current_n]}?: (y/n)"
    local ret=$(_sf_read)
    if [ "$ret" = "y" ];then
      yes=1
      break
    elif [ "$ret" = "n" ];then
      break
    fi
  done
  if [ $yes -eq 1 ];then
    rm -rf ${_s_inputs[$_s_current_n]}
  fi
  sleep 2
  _sf_get_values
  _sf_printall
}

_sf_s () { # {{{
  clear >/dev/tty
  ls -l "${_s_inputs[$_s_current_n]}" >/dev/tty
  local dummy=$(_sf_read)
  _sf_printall
} # }}}

_sf_l () { # {{{
  clear >/dev/tty
  less ${_s_inputs[$_s_current_n]} >/dev/tty </dev/tty
  _sf_quit
} # }}}

_sf_v () { # {{{
  vim ${_s_inputs[$_s_current_n]} >/dev/tty </dev/tty
  _sf_quit
} # }}}

echo "$menu" | _sf_main $*

