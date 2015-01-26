# -*- coding: utf8 -*-
__author__ = "Wenzheng Li"

import numpy as np
import cv2
from matplotlib import pyplot as plt
import math
import sys

def check_ratio( state_count ):
    total_finder_size = 0
    for i in range(5):
        count = state_count[i]
        total_finder_size += count
        if count == 0:
            return False
    if total_finder_size < 7:
        return False

    module_size = math.ceil(total_finder_size / 7.0)
    max_variance = module_size / 2.0

    if abs(module_size - state_count[0]) < max_variance and \
       abs(module_size - state_count[1]) < max_variance and \
       abs(3 * module_size - state_count[2]) < 3 * max_variance and \
       abs(module_size - state_count[3]) < max_variance and \
       abs(module_size - state_count[4]) < max_variance:
        return True

    return False


def detect_qr_finder( filename ):
    img = cv2.imread(filename, cv2.IMREAD_GRAYSCALE)
    ret, img = cv2.threshold(img, 128, 255, cv2.THRESH_BINARY)
    # plt.imshow(img, cmap='gray', interpolation = 'bicubic')
    # plt.xticks([]), plt.yticks([])
    # plt.show()
    # cv2.namedWindow('image', cv2.WINDOW_AUTOSIZE)
    # cv2.imshow('image', img)
    # cv2.waitKey(0)
    # cv2.destroyAllWindows()
    state_count = [0] * 5
    state_count[0] = 1
    state_count[1] = 1
    state_count[2] = 3
    state_count[3] = 1
    state_count[4] = 1
    print check_ratio(state_count)



if __name__ == "__main__":
    detect_qr_finder(sys.argv[1])
