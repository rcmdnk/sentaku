#!/usr/bin/env bash

. sentaku -n

_SENTAKU_SEPARATOR=$'\n'

_sf_execute () { # {{{
  :
} # }}}

_sf_select () { # {{{
  vim -d "$_s_first_dir/${_s_inputs[$_s_current_n]}"\
    "$_s_second_dir/${_s_inputs[$_s_current_n]}" </dev/tty
  tput civis >/dev/tty 2>/dev/null || tput vi >/dev/tty 2>/dev/null
} # }}}

_sf_d () {
  local n=$_s_current_n
  if [ $_s_n -eq 1 ];then
    _sf_echo "There is no remained diff"
    _sf_quit
  elif [ $_s_current_n -eq $((_s_n-1)) ];then
    _sf_n_down
    _s_is_print=1
  fi
  local orig_ifs=$IFS
  IFS="$_s_s"
  local inputs
  inputs=()
  local i
  for ((i=0; i<$_s_n; i++));do
    if [ $i -ne $n ];then
      inputs=("${inputs[@]}" "${_s_inputs[$i]}")
    fi
  done
  _s_inputs=("${inputs[@]}")
  IFS=$orig_ifs
  _s_n=${#_s_inputs[@]}
}

_sf_setheader () { # {{{
  _s_show="$_s_first_dir"
  _sf_show 0 $((_s_cols-3))
  local a_dir="$_s_show"
  _s_show="$_s_second_dir"
  _sf_show 0 $((_s_cols-3))
  local b_dir="$_s_show"
  _s_header=""
  if [ $_s_noheader = 1 -o $_s_lines -lt 10 ];then
    return
  elif [ $_s_cols -ge 66 ];then
    _s_header=" $_s_n files are different in
a:$a_dir
b:$b_dir
 [n](n-down), [n]k(n-up), gg(top), G(bottom), [n]gg/G, (go to n),
 ^D(lf page down), ^U(Half page up), ^F(Page down), ^B(Page Up),
 d(delete from the list), Enter/Space(vim diff), q/Esc(quit)
"
  elif [ $_s_cols -ge 40 ];then
      _s_header=" $_s_n values in total
a:$a_dir
b:$b_dir
 vimike updown, e.g)j:up, k:down, gg/G
 d(delete from the list),
 Enter/Space(vim diff), q/Esc(quit)
"
  fi
}  # }}}

if [ $# -ne 2 ];then
  echo "usage: ex_diff_vim dir1 dir2"
  exit 1
fi
_s_first_dir="${1%/}/"
_s_second_dir="${2%/}/"

diff -r "$_s_first_dir" "$_s_second_dir" |grep diff |grep -v Binary|\
  sed "s!.*${_s_second_dir}!!g"|_sf_main
