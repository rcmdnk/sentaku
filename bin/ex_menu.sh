#!/bin/sh

# Example to make menu program

. sentaku -n


_SENTAKU_NOHEADER=1
_SENTAKU_NONUMBER=1

menu="a: Keyboard Input
b: ls
c: pwd
e: date
"

_sf_execute () {
  local n=${1:-0}
  if [ $n -eq 0 ];then
    # Save current display
    tput smcup >/dev/tty 2>/dev/null || tput ti >/dev/tty 2>/dev/null
    echo "Enter words: " >/dev/tty
    read word </dev/tty
    # Restore display
    tput rmcup >/dev/tty 2>/dev/null || tput te >/dev/tty 2>/dev/null
    echo "$word"
  elif [ $n -eq 1 ];then
    ls
  elif [ $n -eq 2 ];then
    pwd
  elif [ $n -eq 3 ];then
    date
  fi
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
