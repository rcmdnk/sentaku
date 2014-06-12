#!/usr/bin/env bash

# example script to use select in pipe

list="aaa bbb ccc ddd eee fff"
ret=$(echo "$list"|sentaku "$@")
#ret=$(echo "$list"|./ex_source_bash.sh)
if [ "x$ret" != "x" ];then
  echo $ret is selected
fi
