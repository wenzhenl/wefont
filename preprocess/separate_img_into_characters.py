#!/usr/bin/python

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


ratio = 0.9 # the percentage of white points to be regarded as white line
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


# two standard for black bars
# the white bar length > white_len = 8
# the black bar length > black_len = 30

white_len = 4
black_len = 40
#  select those valid white row bar
valid_white_bar_rows = []
for x in white_bar_rows:
    if(x[2] > white_len): # length of white bar 
        valid_white_bar_rows.append(x)

black_rows = []
for x in range(len(valid_white_bar_rows)-1):
    if(valid_white_bar_rows[x+1][0] - valid_white_bar_rows[x][1] > black_len):
        black_rows.append((valid_white_bar_rows[x][1]+1, valid_white_bar_rows[x+1][0]-1))

#  select those valid white col bar
valid_white_bar_cols = []
for x in white_bar_cols:
    if(x[2] > white_len): # length of white bar 
        valid_white_bar_cols.append(x)

black_cols = []
for x in range(len(valid_white_bar_cols)-1):
    if(valid_white_bar_cols[x+1][0] - valid_white_bar_cols[x][1] > black_len):
        black_cols.append((valid_white_bar_cols[x][1]+1, valid_white_bar_cols[x+1][0]-1))

if isDebug:
    print '*****************row cooridinates***************'
    for x in black_rows:
        print x

    print '*****************col cooridinates***************'
    for x in black_cols:
        print x

# save the qrcode to png
box = (black_cols[-1][0], black_rows[0][0], black_cols[-1][1], black_rows[0][1])
region = im.crop(box)
region.save('%s_qrcode.png' %f, 'png')

# remove the qrcode img
for x in range(black_cols[-1][0], black_cols[-1][1]+1):
    for y in range(black_rows[0][0], black_rows[0][1]+1):
        pix[x,y] = (255, 255, 255)

if isDebug:
    im.show()

# /////////////////////////////////////////////////////////////////////////////
# ////////////////////////////////////////////////////////////////////////////
# REPROCESS THE IMG AFTER REMOVING QRCODE IMG


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
    print '*****************SECOND TIME row statistics***************'
    for x in white_bar_rows:
        print x

    print '*****************SECOND TIME column statistics***************'
    for x in white_bar_cols:
        print x

# two standard for black bars
# the white bar length > white_len = 8
# the black bar length > black_len = 30

#  select those valid white row bar
valid_white_bar_rows = []
for x in white_bar_rows:
    if(x[2] > white_len): # length of white bar 
        valid_white_bar_rows.append(x)

black_rows = []
for x in range(len(valid_white_bar_rows)-1):
    if(valid_white_bar_rows[x+1][0] - valid_white_bar_rows[x][1] > black_len):
        black_rows.append((valid_white_bar_rows[x][1]+1, valid_white_bar_rows[x+1][0]-1))

#  select those valid white col bar
valid_white_bar_cols = []
for x in white_bar_cols:
    if(x[2] > white_len): # length of white bar 
        valid_white_bar_cols.append(x)

black_cols = []
for x in range(len(valid_white_bar_cols)-1):
    if(valid_white_bar_cols[x+1][0] - valid_white_bar_cols[x][1] > black_len):
        black_cols.append((valid_white_bar_cols[x][1]+1, valid_white_bar_cols[x+1][0]-1))

if isDebug:
    print '*****************SECOND TIME row cooridinates***************'
    for x in black_rows:
        print x

    print '*****************SECOND TIME col cooridinates***************'
    for x in black_cols:
        print x

# //////////////////////////////////////////////////////////////////////////////////////
# /////////////////////END OF SECOND TIME
# ///////////////////////////////////////////////

border = 4
notZero = lambda x: x if x >= 0 else 0
notEnd = lambda x, y: x if x <= y else y

n = 0
for y in black_rows:
    for x in black_cols:
        n = n + 1
        box = (notZero(x[0]-border), notZero(y[0]-border), notEnd(x[1]+border,im.size[0]-1), notEnd(y[1]+border, im.size[1]-1))
        region = im.crop(box)
        region.save('%s_%s.png' % (f, n), 'png')

if n != 117:
    print 'n=', n
    print 'ERROR: UNEXPECTED RESULTS'

if isDebug and n == 117:
    print 'n=', n
    print 'SUCCESS'


if(isDebug == 1):
    for y in white_rows:
        for x in range(im.size[0]):
            pix[x,y] = (255, 102 ,102)

    for x in white_cols:
        for y in range(im.size[1]):
            pix[x, y] = (102, 255, 255)
    im.show()


