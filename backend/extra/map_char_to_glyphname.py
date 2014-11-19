#!/usr/bin/python
# -*- coding: utf8 -*-

# GIVEN A CHARACTER, GET ITS UNICODE
# SEARCH THIS UNICODE IN GLYPHLIST.TXT TO FIND ITS GLYPH NAME
# IF NOT FOUND, NAME IT WITH THE UNICODE

# author : Wenzheng Li

# argv[1] is the file containing those chars
# argv[2] is the glyphlist.txt downloaded from
# http://partners.adobe.com/public/developer/en/opentype/glyphlist.txt


import sys, os

d = {} # dict unicode => glyph name
with open(sys.argv[2], 'r') as glyphlist:
    for line in glyphlist:
        li = line.rstrip()
        if not li.startswith("#"):
            name, unicd = li.split(';')
            d[unicd] = name
            # print name, unicd


with open(sys.argv[1], 'r') as f:
    for line in f:
        li = line.rstrip().decode('utf-8')
        unicd_0x = "0x{:04x}".format(ord(li))
        unicd = unicd_0x[2:] # remove the prefix '0x'
        if(unicd in d):
            print d[unicd]
        else:
            print "uni" + unicd


