# -*- coding: utf8 -*-
__author__ = "Wenzheng Li"

#///////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////
#///////COMMON FUNCTIONS USED IN ZIMO

def decode_qrcode(filename):
    import zbar
    from PIL import Image
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


