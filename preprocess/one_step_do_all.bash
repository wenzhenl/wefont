#!/bin/bash

for i in *.jpg
do
  python read_jpg.py $i 
done

cd pngs

for i in *.png
do
  f=${i%.*}
  sips -s format bmp $i --out ${f}.bmp
  potrace ${f}.bmp
done
