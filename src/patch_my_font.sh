#!/bin/bash

OLDFONT=$1
shift

for f in "$@"
do
    python parse_template.py $f
done

for i in uni*.png
do
  python remove_spacing.py $i
  rm $i
done

for i in uni*.bmp
do
  potrace -s $i
  rm $i
done
ls *.svg > chars.txt
$(brew --prefix)/bin/python3 patch_font.py $OLDFONT chars.txt
rm chars.txt
rm *.svg
