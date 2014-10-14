#!/usr/bin/python

from PIL import Image
from PIL import ImageEnhance
import sys, os

f, e = os.path.splitext(sys.argv[1])
im = Image.open(sys.argv[1])
pix = im.load()
print im.size

tol_1 = 0.9
tol_2 = 0.7
print tol_1 * im.size[0]
print tol_2 * im.size[1]
# transfer a graph to its grey version
total = 0
for y in range(im.size[1]):
    for x in range(im.size[0]):
        g = (pix[x,y][0] + pix[x,y][1] + pix[x,y][2])/3
        total = total + g
        pix[x,y] = (g,g,g)

print total/(im.size[0] * im.size[1])
white_rows = []
for y in range(im.size[1]):
    count = 0
    for x in range(im.size[0]):
        if(pix[x,y][0] < 170):
            break;
        else:
            count = count + 1
    if(count > tol_1 * im.size[0]):
        white_rows.append(y)

white_cols = []
for x in range(im.size[0]):
    count = 0
    for y in range(im.size[1]):
        if(pix[x,y][0] < 110):
            break;
        else:
            count = count + 1
    if(count > tol_2 * im.size[1]):
        white_cols.append(x)

for wy in white_rows:
    for x in range(im.size[0]):
        pix[x,wy] = (255, 0 ,0)

for wx in white_cols:
    print 'x', wx
    for y in range(im.size[1]):
        pix[wx, y] = (255, 0, 0)

im.show()

black_rows = []
for x in range(len(white_rows)-1):
    if(white_rows[x+1] - white_rows[x] > 10):
        black_rows.append((white_rows[x]+1, white_rows[x+1]-1))

black_cols = []
for x in range(len(white_cols)-1):
    if(white_cols[x+1] - white_cols[x] > 10):
        black_cols.append((white_cols[x]+1, white_cols[x+1]-1))

n = 0
for y in black_rows:
    for x in black_cols:
        n = n + 1
        box = (x[0], y[0], x[1], y[1])
        region = im.crop(box)
        region.save('third%s.png' % n, 'png')
# im.save(f+'_g.jpg')

