#!/usr/bin/env bash

. sentaku -n

_SENTAKU_SEPARATOR=$'\n'

_sf_execute () { # {{{
  :
} # }}}

_sf_select () { # {{{
  local dirs=(${_s_inputs[$_s_current_n]})
  if [ "${#dirs[@]}" -ne 2 ];then
    _sf_echo "Sorry, directory path or file name have space, can not recognize."
  else
    vim -d "${dirs[0]}" "${dirs[1]}" </dev/tty
  fi
} # }}}

_sf_d () {
  if [ $_s_n -eq 1 ];then
    _sf_echo "There is no remained diff"
    _sf_quit
  elif [ $_s_current_n -eq $((_s_n-1)) ];then
    _sf_n_down
  fi
  local orig_ifs=$IFS
  IFS="$_s_s"
  local inputs
  inputs=()
  local i
  for ((i=0; i<$_s_n; i++));do
    if [ $i -ne $_s_current_n ];then
      inputs=("${inputs[@]}" "${_s_inputs[$i]}")
    fi
  done
  _s_inputs=("${inputs[@]}")
  IFS=$orig_ifs
  _s_n=${#_s_inputs[@]}
  _s_is_print=1
}

if [ $# -ne 2 ];then
  echo "usage: ex_diff_vim dir1 dir2"
  exit 1
fi

diff -r "$1" "$2" |grep diff |cut -d' ' -f3-|_sf_main
