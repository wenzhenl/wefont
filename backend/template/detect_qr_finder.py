# -*- coding: utf8 -*-
__author__ = "Wenzheng Li"

import numpy as np
import cv2
from matplotlib import pyplot as plt
import math
import sys

# global parameters
thres = 128
MAX_MODULES = 57
MIN_SKIP = 3

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

def cross_check_vertical( start_i, center_j, max_count, ori_state_count_total, img ):
    state_count = [0] * 5
    i = start_i
    while i >= 0 and img[i, center_j] < thres:
        state_count[2] += 1
        i -= 1
    if i < 0:
        return float('nan')
    while i >= 0 and img[i, center_j] >= thres and state_count[1] <= max_count:
        state_count[1] += 1
        i -= 1
    if i < 0 or state_count[1] > max_count:
        return float('nan')
    while i >= 0 and img[i, center_j] < thres and state_count[0] <= max_count:
        state_count[0] += 1
        i -= 1
    if state_count[0] > max_count:
        return float('nan')

    # count down from the center
    i = start_i + 1
    while i < img.shape[0] and img[i, center_j] < thres:
        state_count[2] += 1
        i += 1
    if i == img.shape[0]:
        return float('nan')
    while i < img.shape[0] and img[i, center_j] >= thres and state_count[3] < max_count:
        state_count[3] += 1
        i += 1
    if i == img.shape[0] or state_count[3] >= max_count:
        return float('nan')
    while i < img.shape[0] and img[i, center_j] < thres and state_count[4] < max_count:
        state_count[4] += 1
        i += 1
    if state_count[4] >= max_count:
        return float('nan')

    state_count_total = sum(state_count)
    if 5 * abs(state_count_total - ori_state_count_total) >= 2 * ori_state_count_total:
        return float('nan')
    if check_ratio(state_count) == True:
        return center_from_end(state_count, i)
    else:
        return float('nan')

def center_from_end( state_count, end ):
    return end - state_count[4] - state_count[3] - state_count[2] * 0.5

# x is already in possible_centers
def about_equals( x, y ):
    if abs(x[0] - y[0]) <= x[2] and abs(x[1] - y[1] <= x[2]):
        if abs(x[2] - y[2]) < 1.0 or abs(x[2] - y[2]) <= x[2]:
            return True
        else:
            return False
    return False


def handle_possible_center( state_count, i, j, centers, img):
    state_count_total = sum(state_count)
    center_j = center_from_end(state_count, j)
    center_i = cross_check_vertical(i, center_j, state_count[2],
                                    state_count_total, img)
    if not math.isnan(center_i):
        esitimate_module_size = state_count_total / 7.0
        found = False
        y = (center_i, center_j, esitimate_module_size)
        for x in centers:
            if about_equals(x, y):
                found = True
                break
        if not found:
            centers.append(y)


def draw_color_lines( i, j, total, img ):
    start_i = int(math.ceil(i - total * 0.5))
    end_i = int(math.ceil(i + total * 0.5))
    start_j = int(math.ceil(j - total * 0.5))
    end_j = int(math.ceil(j + total * 0.5))
    if end_i >= img.shape[0] - 1:
        end_i = img.shape[0] - 1
    if end_j >= img.shape[1] - 1:
        end_j = img.shape[1] - 1
    for x in xrange(start_i, end_i):
        for y in xrange(start_j, end_j):
            img[x,y] = [255, 0, 0]


def detect_qr_finder( filename ):
    img = cv2.imread(filename, cv2.IMREAD_GRAYSCALE)
    old_img = cv2.imread(filename, cv2.IMREAD_COLOR)
    ret, img = cv2.threshold(img, thres, 255, cv2.THRESH_BINARY)

    possible_centers = []

    iSkip = MIN_SKIP
    state_count = [0] * 5
    current_state = 0
    rows, cols = img.shape[:2]
    i = iSkip - 1
    while i < rows:
        state_count = [0] * 5
        current_state = 0
        for j in range(cols):
            if img[i,j] < thres:
                if current_state & 0x1 == 1:
                    current_state += 1
                state_count[current_state] += 1
            else:
                if current_state & 0x1 == 1:
                    state_count[current_state] += 1
                else:
                    if current_state == 4:
                        if check_ratio(state_count) == True:
                            handle_possible_center(state_count, i, j,
                                                   possible_centers, img)
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
        i += iSkip

    possible_centers = sorted(possible_centers, key=lambda tup: tup[2], reverse=True)

    # rotate img
    page_finders = possible_centers[:3]
    pts = np.float32([[page_finders[0][1],page_finders[0][0]],\
                       [page_finders[1][1],page_finders[1][0]],\
                       [page_finders[2][1],page_finders[2][0]]])

    p1_p2 = np.linalg.norm(pts[0] - pts[1])
    p1_p3 = np.linalg.norm(pts[0] - pts[2])
    p2_p3 = np.linalg.norm(pts[1] - pts[2])
    new_rows = 0
    new_cols = 0
    if p1_p2 > p1_p3 and p1_p2 > p2_p3:
        bottom_left = page_finders[2]
        if p1_p3 > p2_p3:
            new_rows = p1_p3
            new_cols = p2_p3
            top_left = page_finders[0]
            bottom_right = page_finders[1]
        else:
            new_rows = p2_p3
            new_cols = p1_p3
            top_left = page_finders[1]
            bottom_right = page_finders[0]
    elif p1_p3 > p1_p2 and p1_p3 > p2_p3:
        bottom_left = page_finders[1]
        if p1_p2 > p2_p3:
            new_rows = p1_p2
            new_cols = p2_p3
            top_left = page_finders[0]
            bottom_right = page_finders[2]
        else:
            new_rows = p2_p3
            new_cols = p1_p2
            top_left = page_finders[2]
            bottom_right = page_finders[0]
    elif p2_p3 > p1_p2 and p2_p3 > p1_p3:
        bottom_left = page_finders[0]
        if p1_p2 > p1_p3:
            new_rows = p1_p2
            new_cols = p1_p3
            top_left = page_finders[1]
            bottom_right = page_finders[2]
        else:
            new_rows = p1_p3
            new_cols = p1_p2
            top_left = page_finders[2]
            bottom_right = page_finders[1]
    else:
        print 'ERROR: unexpected situation'

    # for i in xrange(len(possible_centers)):
    #     draw_color_lines(possible_centers[i][0], possible_centers[i][1],
    #                      possible_centers[i][2] * 7.0, old_img)
    #
    page_finders = [top_left, bottom_left, bottom_right]
    for x in page_finders:
        print x
    # new_rows = page_finders[1][0] - page_finders[0][0] + 7.0 * page_finders[0][2]
    # new_cols = page_finders[2][1] - page_finders[1][1] + 7.0 * page_finders[1][2]
    ms = page_finders[0][2] * 7
    # new_rows += ms
    # new_cols += ms
    pts1 = np.float32([[page_finders[0][1],page_finders[0][0]],\
                       [page_finders[1][1],page_finders[1][0]],\
                       [page_finders[2][1],page_finders[2][0]]])
    pts2 = np.float32([[ms,ms],[ms, new_rows - ms],[new_cols - ms, new_rows - ms]])
    M = cv2.getAffineTransform(pts1, pts2)
    old_img = cv2.warpAffine(old_img, M, (new_cols, new_rows))
    print "# of centers:", len(possible_centers)
    # for i in possible_centers:
        # print i
    for i in xrange(6):
    # for i in xrange(len(possible_centers)):
        x = np.array([possible_centers[i][1], possible_centers[i][0], 1])
        y = np.dot(M, x)
        print y
        possible_centers[i] = (y[1], y[0], possible_centers[i][2])
        draw_color_lines(possible_centers[i][0], possible_centers[i][1],
                         possible_centers[i][2] * 7.0, old_img)
    plt.imshow(old_img, cmap='gray', interpolation = 'bicubic')
    # plt.xticks([]), plt.yticks([])
    plt.show()
    # cv2.namedWindow('image', cv2.WINDOW_AUTOSIZE)
    # cv2.imshow('image', img)
    # cv2.waitKey(0)
    # cv2.destroyAllWindows()



if __name__ == "__main__":
    detect_qr_finder(sys.argv[1])
