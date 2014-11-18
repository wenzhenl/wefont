#!/usr/bin/python

import sys, os

f= open(sys.argv[1], 'r')

dic = {}
for line in f:
    line = line.rstrip()
    dic[line[10:14]] = line[2:6]

count = 0
for key in dic:
    print key, dic[key]
    filename = "uni" + key.lower() + ".svg"
    toFile = "tmp/uni" + dic[key].lower() + ".svg"
    if os.path.isfile(filename):
        os.rename(filename, toFile)
        count = count + 1

print count
