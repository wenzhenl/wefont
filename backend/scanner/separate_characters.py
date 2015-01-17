# -*- coding: utf8 -*-
__author__ = "Wenzheng Li"


from PIL import Image
from PIL import ImageEnhance
import argparse
import sys, os

# PARAMETERS SECTION 1
# ratio = 0.85
ratio = 0.8 # the percentage of white points to be regarded as white line
thres = 130 # the threshold of grey level for white

# two standard for black bars
# the white bar length > white_len = 8
# the black bar length > black_len = 30

# PARAMETERS SECTION 2
white_len = 0
black_len = 50

def decode_qrcode(filename):
    import zbar
    # create a reader
    scanner = zbar.ImageScanner()

    # configure the reader
    scanner.parse_config('enable')

    # obtain image data
    pil = Image.open(filename).convert('L')
    width, height = pil.size
    raw = pil.tostring()

    # wrap image data
    image = zbar.Image(width, height, 'Y800', raw)

    # scan the image for barcodes
    scanner.scan(image)

    # extract results
    for symbol in image:
        qrdata = symbol.data
    qrdata = qrdata.decode("utf-8")

    # clean up
    del(image)
    return qrdata

def get_glyph_name(char):
    d = {} # dict unicode => glyph name
    with open("glyphlist.txt", 'r') as glyphlist:
        for line in glyphlist:
            li = line.rstrip()
            if not li.startswith("#"):
                name, unicd = li.split(';')
                d[unicd] = name
                # print name, unicd

    unicd = "{:04x}".format(ord(char))
    if(unicd in d):
        return d[unicd]
    else:
        return "uni" + unicd

    
#******************* COMMAND LINE OPTIONS *******************************#
parser = argparse.ArgumentParser(description="separate image into single " 
                                              "characters")
parser.add_argument("imgname", help="input scanned image of the template")
parser.add_argument("-r", "--ratio", type=float, 
                    help="the percentage of white points to be regarded as "
                         "white line")
parser.add_argument("-t", "--thres", 
                    help="the threshold of grey level for white")
parser.add_argument("-v", "--verbose", action="store_true",
                    help="print more info")
args = parser.parse_args()

if args.ratio:
    ratio = args.ratio

if args.thres:
    thres = args.thres

f, e = os.path.splitext(args.imgname)
im = Image.open(args.imgname)
pix = im.load()

if args.verbose:
    print im.size

grey_level = lambda x: (x[0] + x[1] + x[2])/3

total = 0
for y in range(im.size[1]):
    for x in range(im.size[0]):
        g = grey_level(pix[x,y])
        total = total + g

if args.verbose:
    print 'average grey level', total/(im.size[0] * im.size[1])

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

if args.verbose:
    print '*****************row statistics***************'
    for x in white_bar_rows:
        print x

    print '*****************column statistics***************'
    for x in white_bar_cols:
        print x


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

if args.verbose:
    print '*****************row cooridinates***************'
    for x in black_rows:
        print x

    print '*****************col cooridinates***************'
    for x in black_cols:
        print x

# save the qrcode to png
# box = (black_cols[-1][0], black_rows[0][0], black_cols[-1][1], black_rows[0][1])
# region = im.crop(box)
# region.save('%s_qrcode.png' %f, 'png')

# /////////////////////////////////////////////////////////////////////////////
# ////////////////////////////////////////////////////////////////////////////
# DECODE THE QRCODE
if args.verbose:
    print ">>>BEGIN DECODING QRCODE"
qrdata = decode_qrcode("%s_qrcode.png" % f)
cell_size = int(qrdata[:qrdata.find(" ")])
if args.verbose:
    print "cell size: ", cell_size
qrdata = qrdata[qrdata.find(" ") + 1:]
chars = []
for char in qrdata:
    chars.append(char)
    if args.verbose:
        print char, 
if args.verbose:
    print len(chars)
n_chars = len(chars)


# remove the qrcode img
for x in range(black_cols[-1][0], black_cols[-1][1]+1):
    for y in range(black_rows[0][0], black_rows[0][1]+1):
        pix[x,y] = (255, 255, 255)

if args.verbose:
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

if args.verbose:
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

if args.verbose:
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

n = len(black_rows) * len(black_cols) - 6
if n != n_chars:
    print '-----', f
    print 'n=', n
    print 'ERROR: UNEXPECTED RESULTS'

if args.verbose and n == n_chars:
    print 'n=', n
    print 'SUCCESS'


if n == n_chars:
    count = 0
    for j in range(len(black_rows)):
        for i in range(len(black_cols)):
            if j == 0 and i == 0:
                continue
            elif j == len(black_rows) - 1 and i == len(black_cols) - 1:
                continue
            elif i == len(black_cols) - 1 and j == 0:
                continue
            elif i == len(black_cols) - 1 and j == 1:
                continue
            elif i == len(black_cols) - 2 and j == 0:
                continue
            elif i == len(black_cols) - 2 and j == 1:
                continue
            else:
                x = black_cols[i]
                y = black_rows[j]
                box = (notZero(x[0]-border), notZero(y[0]-border), 
                    notEnd(x[1]+border,im.size[0]-1), notEnd(y[1]+border, im.size[1]-1))
                region = im.crop(box)
                glyname = get_glyph_name(chars[count])
                count += 1
                region.save(glyname + '.png', 'png')

if args.verbose:
    for y in white_rows:
        for x in range(im.size[0]):
            pix[x,y] = (255, 102 ,102)

    for x in white_cols:
        for y in range(im.size[1]):
            pix[x, y] = (102, 255, 255)
    im.show()
