#!/bin/bash

OUTPUT=$1

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
/opt/homebrew/bin/python3 generate_font.py chars.txt $OUTPUT
rm chars.txt
rm *.svg
