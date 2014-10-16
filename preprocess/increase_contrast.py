#!/usr/bin/python

from PIL import Image
from PIL import ImageEnhance
import sys, os

f, e = os.path.splitext(sys.argv[1])
enhtor = int(sys.argv[2])
im = Image.open(sys.argv[1])
pix = im.load()
# print im.size
enh = ImageEnhance.Contrast(im)
con = enh.enhance(enhtor)
con.save(f+'.bmp')
# con.show("30% more contrast")
