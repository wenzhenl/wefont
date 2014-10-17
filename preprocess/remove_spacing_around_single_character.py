#!/usr/bin/python

# THE PURPOSE IS TO REMOVE THE EXTRA SPACING AROUND A SINGLE CHARACTER
# NEXT STEP IS TO RESIZE EACH CHARACTER TO THE SAME SIZE

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

# PARAMETERS SECTION 1
ratio = 0.95 # the percentage of white points to be regarded as white line
thres = 130 # the threshold of grey level for white

grey_level = lambda x: (x[0] + x[1] + x[2])/3

total = 0
for y in range(im.size[1]):
    for x in range(im.size[0]):
        g = grey_level(pix[x,y])
        total = total + g

if isDebug:
    print 'ave grey level', total/(im.size[0] * im.size[1])

white_rows = []
for y in range(im.size[1]):
    count = 0
    for x in range(im.size[0]):
        if(grey_level(pix[x,y]) < thres):
            break;
        else:
            count = count + 1
    if(count > ratio * im.size[0]):
        white_rows.append(y)

white_cols = []
for x in range(im.size[0]):
    count = 0
    for y in range(im.size[1]):
        if(grey_level(pix[x,y]) < thres):
            break;
        else:
            count = count + 1
    if(count > ratio * im.size[1]):
        white_cols.append(x)

white_bar_cols = []
if len(white_cols) > 0:
    start = white_cols[0]
    for x in range(len(white_cols)-1):
        if white_cols[x+1] - white_cols[x] > 1:
            white_bar_cols.append((start, white_cols[x], white_cols[x]-start+1))
            start = white_cols[x+1]
    last_col = white_cols[-1]
    white_bar_cols.append((start, last_col, last_col-start+1))

white_bar_rows = []
if len(white_rows) > 0:
    start = white_rows[0]
    for x in range(len(white_rows)-1):
        if white_rows[x+1] - white_rows[x] > 1:
            white_bar_rows.append((start, white_rows[x], white_rows[x]-start+1))
            start = white_rows[x+1]
    last_row = white_rows[-1]
    white_bar_rows.append((start, last_row, last_row-start+1))

if isDebug:
    print '*****************row statistics***************'
    for x in white_bar_rows:
        print x

    print '*****************column statistics***************'
    for x in white_bar_cols:
        print x

# PARAMETERS SECTION 2
white_len = 1

#  select those valid white row bar
valid_white_bar_rows = []
for x in white_bar_rows:
    if(x[2] > white_len): # length of white bar 
        valid_white_bar_rows.append(x)

# the top white row bar to remove must start from 0, namely the toppest line
# the bottom white row bar to remove must end at im.size[1], namely the bottom line
black_rows = []
if not valid_white_bar_rows:
    black_rows.append((0, im.size[1]-1))
elif valid_white_bar_rows[0][0] == 0 and valid_white_bar_rows[-1][1] == im.size[1]-1:
    black_rows.append((valid_white_bar_rows[0][1]+1, valid_white_bar_rows[-1][0]-1))
elif valid_white_bar_rows[0][0] == 0 and valid_white_bar_rows[-1][1] != im.size[1]-1:
    black_rows.append((valid_white_bar_rows[0][1]+1, im.size[1]-1))
elif valid_white_bar_rows[0][0] != 0 and valid_white_bar_rows[-1][1] == im.size[1]-1:
    black_rows.append((0, valid_white_bar_rows[-1][0]-1))
elif valid_white_bar_rows[0][0] != 0 and valid_white_bar_rows[-1][1] != im.size[1]-1:
    black_rows.append((0, im.size[1]-1))

#  select those valid white col bar
valid_white_bar_cols = []
for x in white_bar_cols:
    if(x[2] > white_len): # length of white bar 
        valid_white_bar_cols.append(x)

# the left white col bar to remove must start from 0, namely the leftest line
# the right white col bar to remove must end at im.size[0], namely the rightest line
black_cols = []
if not valid_white_bar_cols:
    black_cols.append((0, im.size[0]-1))
elif valid_white_bar_cols[0][0] == 0 and valid_white_bar_cols[-1][1] == im.size[0]-1:
    black_cols.append((valid_white_bar_cols[0][1]+1, valid_white_bar_cols[-1][0]-1))
elif valid_white_bar_cols[0][0] == 0 and valid_white_bar_cols[-1][1] != im.size[0]-1:
    black_cols.append((valid_white_bar_cols[0][1]+1, im.size[0]-1))
elif valid_white_bar_cols[0][0] != 0 and valid_white_bar_cols[-1][1] == im.size[0]-1:
    black_cols.append((0, valid_white_bar_cols[-1][0]-1))
elif valid_white_bar_cols[0][0] != 0 and valid_white_bar_cols[-1][1] != im.size[0]-1:
    black_cols.append((0, im.size[0]-1))


border = 4
notZero = lambda x: x if x >= 0 else 0
notEnd = lambda x, y: x if x <= y else y

for y in black_rows:
    for x in black_cols:
        box = (notZero(x[0]-border), notZero(y[0]-border), notEnd(x[1]+border,im.size[0]-1), notEnd(y[1]+border, im.size[1]-1))
        region = im.crop(box)
        region.save('%s_ars.png' % f, 'png')

if isDebug:
    print f


if(isDebug == 1):
    for y in white_rows:
        for x in range(im.size[0]):
            pix[x,y] = (255, 102 ,102)

    for x in white_cols:
        for y in range(im.size[1]):
            pix[x, y] = (102, 255, 255)
    im.show()


