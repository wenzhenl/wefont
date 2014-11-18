#!/usr/bin/python

import sys
import fontforge

f= open(sys.argv[1], 'r')

dic = {}
for line in f:
    line = line.rstrip()
    dic[line[10:14].lower()] = line[2:6].lower()


f2= open(sys.argv[2], 'r')

font = fontforge.font()

family_name = "Leeyukuang"
font.familyname = family_name
font.familyname = family_name
font.fullname = family_name
font.encoding = "gb2312"

for line in f2:
    line = line.rstrip()
    glyph = font.createMappedChar(int(dic[line[3:]], 16))
    glyph.importOutlines("uni" + line[3:] + ".svg")

font.generate('Lee.ttf')
