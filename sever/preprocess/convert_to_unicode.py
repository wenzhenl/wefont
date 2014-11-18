#!/usr/bin/python
# -*- coding: utf8 -*-


import sys, os

f= open(sys.argv[1], 'r')

for line in f:
    line = line.rstrip()
    print repr(line.decode('utf-8'))
