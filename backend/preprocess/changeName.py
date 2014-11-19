#!/usr/bin/python
import sys, os

f= open(sys.argv[1], 'r')

unicodes = []
for line in f:
    line = line.rstrip()
    unicodes.append(line)


count = 0
for i in range(23):
    for j in range(117):
        filename = "L00-" + str(i) + "_" + str(j) + "_ars.bmp" 
        if os.path.isfile(filename):
            os.rename(filename, unicodes[count]+".bmp")
            count = count + 1

print count
