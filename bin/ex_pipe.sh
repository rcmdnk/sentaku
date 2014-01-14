#!/bin/sh

# example script to use select in pipe

list="aaa
bbb
ccc"
#select=$(echo "$list"|./sentaku)
select=$(echo "$list"|./ex_source_bash.sh)
echo $select is selected
