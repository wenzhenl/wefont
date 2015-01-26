# -*- coding: utf8 -*-
__author__ = "Wenzheng Li"

import numpy as np
import cv2
from matplotlib import pyplot as plt
import math
import sys

# global parameters
thres = 128

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
    # old_img = cv2.imread(filename, cv2.IMREAD_COLOR)
    ret, img = cv2.threshold(img, thres, 255, cv2.THRESH_BINARY)
    # print old_img.shape[:2]
    # print img.shape[:2]
    state_count = [0] * 5
    current_state = 0
    rows, cols = img.shape[:2]
    fb = 0 #
    for i in range(rows):
        state_count = [0] * 5
        current_state = 0
        for j in range(cols):
            if img[i,j] < thres:
                if current_state & 0x1 == 1:
                    current_state += 1
                if current_state == 0: #
                    fb = j #
                state_count[current_state] += 1
            else:
                if current_state & 0x1 == 1:
                    state_count[current_state] += 1
                else:
                    if current_state == 4:
                        if check_ratio(state_count) == True:
                            if fb: #
                                for k in range(fb, j): #
                                    img[i,k] = 255 #
                        else:
                            current_state = 3
                            state_count[0] = state_count[2]
                            state_count[1] = state_count[3]
                            state_count[2] = state_count[4]
                            state_count[3] = 1
                            state_count[4] = 0
                            continue
                        state_count = [0] * 5
                        current_state = 0
                    else:
                        current_state += 1
                        state_count[current_state] += 1

    plt.imshow(img, cmap='gray', interpolation = 'bicubic')
    plt.xticks([]), plt.yticks([])
    plt.show()
    # cv2.namedWindow('image', cv2.WINDOW_AUTOSIZE)
    # cv2.imshow('image', img)
    # cv2.waitKey(0)
    # cv2.destroyAllWindows()



if __name__ == "__main__":
    detect_qr_finder(sys.argv[1])
