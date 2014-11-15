#!/usr/bin/python

import sys
import fontforge
import string

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

lower = string.lowercase
for i in lower:
    glyph = font.createMappedChar(ord(i))
    glyph.importOutlines("lower"+i+".svg")

upper = string.uppercase
for i in upper:
    glyph = font.createMappedChar(ord(i))
    glyph.importOutlines(i+".svg")

nums = [zero,one,two,three,four,five,six,seven,eight,nine]
for i in range(10):
    glyph = font.createMappedChar(ord(str(i)))
    glyph.importOutlines(nums[i]+".svg")

font.generate('Lee.ttf')
