#!/usr/bin/python

# ////////////////////////
# ////////  WHITEN  ////////
#///////////////////////////

# THE PURPOSE IS TO PROCESS IMAGE TAKEN FROM CAMERA INSTEAD OF SCANNER,
# TO WHITEN THE NOISE OF THE ENVIRONMENT

# author: Wenzheng Li

from PIL import Image
from PIL import ImageEnhance
import sys, os

f, e = os.path.splitext(sys.argv[1])
im = Image.open(sys.argv[1])
pix = im.load()

if len(sys.argv) > 2:
    isDebug = 1
else:
    isDebug = 0

if isDebug:
    print im.size

grey_level = lambda x: (x[0] + x[1] + x[2])/3

total = 0
for y in range(im.size[1]):
    for x in range(im.size[0]):
        g = grey_level(pix[x,y])
        total = total + g

ave_grep_level = total/(im.size[0] * im.size[1])

if isDebug:
    print 'ave grey level', ave_grep_level

# PARAMETERS SECTION 1
thres = ave_grep_level * 0.5 # the threshold of grey level for white

for y in range(im.size[1]):
    for x in range(im.size[0]):
        if(grey_level(pix[x,y]) < thres):
            pass;
        else:
            pix[x,y] = (255,255,255)

if isDebug:
    print f

if isDebug:
    im.show()

im.save('%s_aw.png' % f, 'png')
