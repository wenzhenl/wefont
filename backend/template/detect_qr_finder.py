# -*- coding: utf8 -*-
__author__ = "Wenzheng Li"

import numpy as np
import cv2
from matplotlib import pyplot as plt
import sys

def detect_qr_finder( filename ):
    img = cv2.imread(filename, cv2.IMREAD_GRAYSCALE)
    ret, img = cv2.threshold(img, 127, 255, cv2.THRESH_BINARY)
    plt.imshow(img, cmap='gray', interpolation = 'bicubic')
    plt.xticks([]), plt.yticks([])
    plt.show()
    # cv2.namedWindow('image', cv2.WINDOW_AUTOSIZE)
    # cv2.imshow('image', img)
    # cv2.waitKey(0)
    # cv2.destroyAllWindows()



if __name__ == "__main__":
    detect_qr_finder(sys.argv[1])
