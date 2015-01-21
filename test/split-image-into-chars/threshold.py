# -*- coding: utf8 -*-
__author__ = "Wenzheng Li"


from PIL import Image
from PIL import ImageEnhance
import sys, os

im = Image.open(sys.argv[1])
pix = im.load()

grey_level = lambda x: (x[0] + x[1] + x[2])/3

thres = 150
for y in range(im.size[1]):
    for x in range(im.size[0]):
        if grey_level(pix[x,y]) > thres:
            pix[x,y] = (255, 255, 255)
        else:
            pix[x,y] = (0,0,0)

im.show()

