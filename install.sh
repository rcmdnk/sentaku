#!/usr/bin/env bash
repo=https://raw.github.com/rcmdnk/sentaku/master
scripts=($repo/bin/sentaku $repo/bin/ddv)
if [[ $# -ge 1 ]];then
  if [[ "$1" = --prefix=* ]];then
    prefix="${$1#*=}"
  elif [[ "$1" = "--prefix" || "$1" = "-p" ]];then
    prefix="$2"
  fi
fi
if [ -z "$prefix" ];then
  prefix=/usr
fi

echo
echo "###############################################"
echo "Install to $prefix/bin"
echo "###############################################"
echo
sudo=""
if [ -d $prefix/bin ];then
  touch $prefix/bin/.install.test >& /dev/null
  if [ $? -ne 0 ];then
    sudo=sudo
  else
    rm -f $prefix/bin/.install.test
  fi
else
  mkdir -p $prefix/bin>&  /dev/null
  if [ $? -ne 0 ];then
    sudo mkdir -p $prefix/bin
    sudo=sudo
  fi
fi

for s in ${scripts[@]};do
  sname=`basename $s`
  echo Intalling ${sname}...
  $sudo curl -fsSL -o $prefix/bin/$sname $s
  $sudo chmod 755 $prefix/bin/$sname
done
