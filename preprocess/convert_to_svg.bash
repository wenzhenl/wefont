#!/bin/bash

DIR=$1
cnt=0

for i in $DIR/*
do
  ((cnt++))
  echo $cnt
  f=`basename $i`
  potrace -s -W 100 -H 100 $i -o all_my_svg/${f%*}.svg
done
