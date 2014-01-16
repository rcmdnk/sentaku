#!/usr/bin/env bash

# Example to make new scripts with sentaku functions

. sentaku -n

_sf_a () {
  _sf_echo_printall "in function a
Check Shell
BASH_VERSION: $BASH_VERSION
ZSH_VERSION: $ZSH_VERSION"
}
_sf_l () {
  _sf_echo_printall "$(pwd;ls)"
  #clear >/dev/tty
  #pwd >/dev/tty
  #ls >/dev/tty
  #local dummy=$(_sf_read)
  #_sf_printall
}

_sf_main $*
