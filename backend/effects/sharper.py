# -*- coding: utf8 -*-
__author__ = "Wenzheng Li"


import numpy as np
import sys
import fontforge
import cv2

font = fontforge.open(sys.argv[1])

print "Font Name : %s" % font.fontname
print "Full Name : %s" % font.fullname
print "Family Name : %s" % font.familyname
print "Version : %s" % font.version
print "Copyright : %s" % font.copyright

for g in [glyph.glyphname for glyph in font.glyphs()]:
    print g
    old = font[g]
    new = font.createChar(-1, 'dummytmp')

    pen = new.glyphPen()
    for  contour in old.layers[1]:
        pen.moveTo((contour[0].x, contour[0].y))
        for point in contour[1:]:
            if point.on_curve:
                pen.lineTo((point.x, point.y))
        pen.endPath()
    old.clear()
    old.addReference("dummytmp")
font.removeGlyph("dummytmp")
font.generate("JingleiSharpened.ttf")
