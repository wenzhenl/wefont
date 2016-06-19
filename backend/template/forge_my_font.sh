#!/bin/bash

INPUT=$1
python parse_template.py $INPUT

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
python generate_font.py chars.txt
rm chars.txt
rm *.svg
