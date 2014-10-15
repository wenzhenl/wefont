#!/usr/bin/python

# created: 01.04.2008

# Thanks to Dinu C. Gherman for providing the
# code example on http://python.net/~gherman/pdf2tiff.html

import sys
import os
from os.path import splitext
from objc import YES, NO
from Foundation import NSData
from AppKit import *

NSApp = NSApplication.sharedApplication()

def main():
    action = sys.argv[1].decode('utf-8')
    if action == u'getpagecount':
        pdfpath = sys.argv[2].decode('utf-8')
        print getpagecount(pdfpath)
    elif action == u'pdf2jpg':
        pdfpath = sys.argv[2].decode('utf-8')
        resolution = int(sys.argv[3].decode('utf-8'))
        pdf2jpg(pdfpath, resolution)

def pdf2jpg(pdfpath, resolution=72):
    """I am converting all pages of a PDF file to JPG images."""
    
    pdfdata = NSData.dataWithContentsOfFile_(pdfpath)
    pdfrep = NSPDFImageRep.imageRepWithData_(pdfdata)
    pagecount = pdfrep.pageCount()
    for i in range(0, pagecount):
        pdfrep.setCurrentPage_(i)
        pdfimage = NSImage.alloc().init()
        pdfimage.addRepresentation_(pdfrep)
        origsize = pdfimage.size()
        width, height = origsize
        pdfimage.setScalesWhenResized_(YES)
        rf = resolution / 72.0
        pdfimage.setSize_((width*rf, height*rf))
        tiffimg = pdfimage.TIFFRepresentation()
        bmpimg = NSBitmapImageRep.imageRepWithData_(tiffimg)
        data = bmpimg.representationUsingType_properties_(NSJPEGFileType, {NSImageCompressionFactor: 1.0})
        jpgpath = "%s-%d.jpg" % (splitext(pdfpath)[0], i)
        if not os.path.exists(jpgpath):
            data.writeToFile_atomically_(jpgpath, False)

def getpagecount(pdfpath):
    """I am returning the total page count of a PDF file."""

    pdfdata = NSData.dataWithContentsOfFile_(pdfpath)
    pdfrep = NSPDFImageRep.imageRepWithData_(pdfdata)
    pagecount = pdfrep.pageCount()
    return pagecount

if __name__ == '__main__':
    main()