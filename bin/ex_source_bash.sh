#!/usr/bin/env bash

# Example to make new scripts with sentaku functions

. sentaku -n

_SENTAKU_INPUT_FILE="$HOME/.my_input"

_sf_a () {
  clear >/dev/tty
  echo "in function a" >/dev/tty
  echo "Check Shell" >/dev/tty
  echo "BASH_VERSION: $BASH_VERSION" >/dev/tty
  echo "ZSH_VERSION: $ZSH_VERSION" >/dev/tty
  local dummy=$(_sf_read)
  _sf_printall
}
_sf_l () {
  clear >/dev/tty
  pwd >/dev/tty
  ls >/dev/tty
  local dummy=$(_sf_read)
  _sf_printall
}

_sf_main $*
