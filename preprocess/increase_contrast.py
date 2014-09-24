#!/usr/bin/python

from PIL import Image
from PIL import ImageEnhance
import sys, os

f, e = os.path.splitext(sys.argv[1])
im = Image.open(sys.argv[1])
pix = im.load()
print im.size
enh = ImageEnhance.Contrast(im)
con = enh.enhance(10)
con.save(f+'.bmp')
con.show("30% more contrast")
# for x in range(im.size[0]):
#     for y in range(im.size[1]):
#         if(pix[x,y][0] < 100):
#             pix[x,y] = (255,255,255) 
#         else:
#             pix[x,y] = (0,0,0)
# im.show()
# im.save('yuening.jpg')

# im.show();
# box = (135, 60, 235, 160)
# region = im.crop(box)
# region.show()
# print region.size
# pix = region.load()
# for x in range(region.size[0]):
#     for y in range(region.size[1]):
#         if(pix[x,y][0] < 100):
#             pix[x,y] = (255,255,255)
#         else:
#             pix[x,y] = (0,0,0)
#
# im.paste(region,box)
# im.show()
