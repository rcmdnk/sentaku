#!/usr/bin/env bash

# example script to use emacs mode

export SENTAKU_KEYMODE=1
list="aaa abc xxxaaaxxx bbbAAA cccaaaXXX"
ret=$(echo $list|sentaku "$@")
if [ "x$ret" != "x" ];then
  echo $ret is selected
fi
