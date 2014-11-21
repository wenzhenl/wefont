#!/usr/bin/python
# -*- coding: utf8 -*-

from qrcode import *

qr = QRCode(version=20, error_correction=ERROR_CORRECT_L)
qr.add_data("我是色狼二百五")
qr.make() # Generate the QRCode itself

# im contains a PIL.Image.Image object
im = qr.make_image()

# To save it
im.save("haha.png")
