#!/usr/bin/env zsh

# Example to make new scripts with sentaku functions

. sentaku -n

_SENTAKU_INPUT_FILE="$HOME/.my_input"

_sf_a () {
  clear >/dev/tty
  echo "in function a" >/dev/tty
  sleep 3
  _sf_printall
}
_sf_l () {
  clear >/dev/tty
  pwd >/dev/tty
  ls >/dev/tty
  read -s -k 1 c </dev/tty
  _sf_printall
}

_sf_main $*
