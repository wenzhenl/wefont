# -*- coding: utf8 -*-
__author__ = "Wenzheng Li"


import numpy as np
import sys, os
import os.path
import fontforge
import cv2

font = fontforge.open(sys.argv[1])

print "Font Name : %s" % font.fontname
print "Full Name : %s" % font.fullname
print "Family Name : %s" % font.familyname
print "Version : %s" % font.version
print "Copyright : %s" % font.copyright

font.fontname += " Mirror"
font.fullname += " Mirror "
font.fontname += "-Mirror"

for g in [glyph.glyphname for glyph in font.glyphs()]:
    print g
    old = font[g]
    # old.export(g + '.bmp')
    if os.path.isfile(g + '.svg'):
        old.clear()
        old.importOutlines(g + '.svg')
font.generate("JingleiMirror.ttf")
