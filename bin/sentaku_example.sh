#!/bin/sh
list="aaa
bbb
ccc"
select=$(echo "$list"|./sentaku)
echo selected $select
