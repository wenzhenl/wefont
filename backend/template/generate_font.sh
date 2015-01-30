#!/bin/bash

for i in uni*.png
do
  python remove_spacing.py $i
done

for i in uni*.bmp
do
  potrace -s $i 
done
ls *.svg > chars.txt
python generate_font.py chars.txt
