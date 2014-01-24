#!/bin/sh

# Example to make menu program

. sentaku -n

_SENTAKU_SEPARATOR=$'\n'
_SENTAKU_NOHEADER=1
_SENTAKU_NONUMBER=1

menu="a: Keyboard Input
b: ls
c: pwd
d: date
e: more
"

_sf_initialize_user () {
  _s_selected=""
}

_sf_execute () {
  echo "$_s_selected"
}

_sf_a () {
  # clear after selection
  clear >/dev/tty

  echo "Enter words: " >/dev/tty
  # Show cursor
  tput cnorm >/dev/tty 2>/dev/null || tput vs >/dev/tty 2>/dev/null
  read _s_selected </dev/tty

  _s_break=1
}
_sf_b () {
  _s_selected=$(ls)
  _s_break=1
}
_sf_c () {
  _s_selected=$(pwd)
  _s_break=1
}
_sf_d () {
  _s_selected=$(date)
  _s_break=1
}
_sf_e () {
  _s_selected=$(_sf_more)
  if [ "$_s_selected" != "" ];then
    _s_break=1
  fi
}

_sf_select () {
  if [ $_s_current_n -eq 0 ];then
    _sf_a
  elif [ $_s_current_n -eq 1 ];then
    _sf_b
  elif [ $_s_current_n -eq 2 ];then
    _sf_c
  elif [ $_s_current_n -eq 3 ];then
    _sf_d
  elif [ $_s_current_n -eq 4 ];then
    _sf_e
  fi
}

_sf_more () { # {{{

  . sentaku -n -c

  _SENTAKU_SEPARATOR=$'\n'
  _SENTAKU_NOHEADER=1
  _SENTAKU_NONUMBER=1

  menu="a: echo aaa
b: echo bbb
c: echo ccc
d: echo ddd
"

  _sf_execute () {
    echo ${_s_inputs[$_s_current_n]: 7}
  }

  _sf_a () {
    _s_current_n=0
    _s_break=1
  }
  _sf_b () {
    _s_current_n=1
    _s_break=1
  }
  _sf_c () {
    _s_current_n=2
    _s_break=1
  }
  _sf_d () {
    _s_current_n=3
    _s_break=1
  }
  echo "$menu" | _sf_main
} # }}}

echo "$menu" | _sf_main "$@"
