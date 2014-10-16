#!/usr/bin/python

from PIL import Image
from PIL import ImageEnhance
import sys, os

f, e = os.path.splitext(sys.argv[1])
im = Image.open(sys.argv[1])
pix = im.load()
print im.size

if len(sys.argv) > 2:
    isDebug = 1
else:
    isDebug = 0

ratio = 0.8 
thres = 110 # the threshold of grey level for white


# transfer a graph to its grey version
total = 0
for y in range(im.size[1]):
    for x in range(im.size[0]):
        g = (pix[x,y][0] + pix[x,y][1] + pix[x,y][2])/3
        total = total + g
        pix[x,y] = (g,g,g)

print 'ave grey level', total/(im.size[0] * im.size[1])

white_rows = []
for y in range(im.size[1]):
    count = 0
    for x in range(im.size[0]):
        if(pix[x,y][0] < thres):
            break;
        else:
            count = count + 1
    if(count > ratio * im.size[0]):
        white_rows.append(y)

white_cols = []
for x in range(im.size[0]):
    count = 0
    for y in range(im.size[1]):
        if(pix[x,y][0] < thres):
            break;
        else:
            count = count + 1
    if(count > ratio * im.size[1]):
        white_cols.append(x)

white_bar_cols = []
start = white_cols[0]
for x in range(len(white_cols)-1):
    if white_cols[x+1] - white_cols[x] > 1:
        white_bar_cols.append((start, white_cols[x], white_cols[x]-start+1))
        start = white_cols[x+1]
last_col = white_cols[len(white_cols)-1]
white_bar_cols.append((start, last_col, last_col-start+1))

white_bar_rows = []
start = white_rows[0]
for x in range(len(white_rows)-1):
    if white_rows[x+1] - white_rows[x] > 1:
        white_bar_rows.append((start, white_rows[x], white_rows[x]-start+1))
        start = white_rows[x+1]
last_row = white_rows[len(white_rows)-1]
white_bar_rows.append((start, last_row, last_row-start+1))

print '*****************row statistics***************'
for x in white_bar_rows:
    print x

print '*****************column statistics***************'
for x in white_bar_cols:
    print x

# if(isDebug == 1):
#     for wy in white_rows:
#         for x in range(im.size[0]):
#             pix[x,wy] = (255, 102 ,102)
#
#     for wx in white_cols:
#         for y in range(im.size[1]):
#             pix[wx, y] = (102, 255, 255)
#     im.show()
#


# two standard for black bars
# the white bar length > white_len = 8
# the black bar length > black_len = 30

white_len = 8
black_len = 30
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

im.show()

# /////////////////////////////////////////////////////////////////////////////
# ////////////////////////////////////////////////////////////////////////////
# reprocess the img after removing qrcode img


white_rows = []
for y in range(im.size[1]):
    count = 0
    for x in range(im.size[0]):
        if(pix[x,y][0] < thres):
            break;
        else:
            count = count + 1
    if(count > ratio * im.size[0]):
        white_rows.append(y)

white_cols = []
for x in range(im.size[0]):
    count = 0
    for y in range(im.size[1]):
        if(pix[x,y][0] < thres):
            break;
        else:
            count = count + 1
    if(count > ratio * im.size[1]):
        white_cols.append(x)

white_bar_cols = []
start = white_cols[0]
for x in range(len(white_cols)-1):
    if white_cols[x+1] - white_cols[x] > 1:
        white_bar_cols.append((start, white_cols[x], white_cols[x]-start+1))
        start = white_cols[x+1]
last_col = white_cols[len(white_cols)-1]
white_bar_cols.append((start, last_col, last_col-start+1))

white_bar_rows = []
start = white_rows[0]
for x in range(len(white_rows)-1):
    if white_rows[x+1] - white_rows[x] > 1:
        white_bar_rows.append((start, white_rows[x], white_rows[x]-start+1))
        start = white_rows[x+1]
last_row = white_rows[len(white_rows)-1]
white_bar_rows.append((start, last_row, last_row-start+1))

print '*****************SECOND TIME row statistics***************'
for x in white_bar_rows:
    print x

print '*****************SECOND TIME column statistics***************'
for x in white_bar_cols:
    print x

if(isDebug == 1):
    for wy in white_rows:
        for x in range(im.size[0]):
            pix[x,wy] = (255, 102 ,102)

    for wx in white_cols:
        for y in range(im.size[1]):
            pix[wx, y] = (102, 255, 255)
    im.show()

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

print '*****************row cooridinates***************'
for x in black_rows:
    print x

print '*****************col cooridinates***************'
for x in black_cols:
    print x

im.show()
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

print 'n=', n
if n != 117:
    print 'ERROR: UNEXPECTED RESULTS'
