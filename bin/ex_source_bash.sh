#!/usr/bin/env bash

# Example to make new scripts with sentaku functions

. sentaku -n

# User Default Variables
_SENTAKU_INPUT_FILE="$HOME/.my_input"
_SENTAKU_SEPARATOR=$'\x07'

_sf_a () {
  _sf_echo "in function a
Check Shell
BASH_VERSION: $BASH_VERSION
ZSH_VERSION: $ZSH_VERSION"
}
_sf_l () {
  _sf_echo "$(pwd;ls)"
}

_sf_main "$@"
