# -*- coding: utf8 -*-
__author__ = "Wenzheng Li"

import numpy as np
import cv2
from matplotlib import pyplot as plt
import math
import sys
import zbar

# GLOBAL PARAMETERS
thres = 128
MIN_SKIP = 3


# //////////////////////////////////////////////
# ////// GET GLYPH NAME //////////////
# //////////////////////////////////////////////
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


# //////////////////////////////////////////////
# ////// DECODE A QRCODE //////////////
# //////////////////////////////////////////////
def decode_qrcode( qrcode ):
    # create a reader
    scanner = zbar.ImageScanner()

    # configure the reader
    scanner.parse_config('enable')

    # obtain image data
    height, width = qrcode.shape
    raw = qrcode.tostring()

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

#//////////////////////////////////////////////
#////// CHECK RATIO IS 1:1:3:1:1 //////////////
#//////////////////////////////////////////////
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


# ////////////////////////////////////////////////
# ////////// CHECK VERTICAL MEETS 1:1:3:1:1 /////
# //////////////////////////////////////////////
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


# ////////////////////////////////////////////////
# ////////// CHECK HORIZONTAL MEETS 1:1:3:1:1 /////
# //////////////////////////////////////////////

def cross_check_horizontal(center_i, start_j, max_count, ori_state_count_total, img ) :
    state_count = [0] * 5
    cols = img.shape[1]
    j = start_j
    while j >= 0 and img[center_i, j] < thres:
        state_count[2] += 1
        j -= 1
    if j < 0:
        return float('nan')
    while j >= 0 and img[center_i, j] >= thres and state_count[1] <= max_count:
        state_count[1] += 1
        j -= 1
    if j < 0 or state_count[1] > max_count:
        return float('nan')
    while j >= 0 and img[center_i, j] < thres and state_count[0] <= max_count:
        state_count[0] += 1
        j -= 1
    if state_count[0] > max_count:
        return float('nan')

    j = start_j + 1
    while j < cols and img[center_i, j] < thres:
        state_count[2] += 1
        j += 1
    if j == cols:
        return float('nan')
    while j < cols and img[center_i, j] >= thres and state_count[3] < max_count:
        state_count[3] += 1
        j += 1
    if j == cols or state_count[3] >= max_count:
        return float('nan')
    while j < cols and img[center_i, j] < thres and state_count[4] < max_count:
        state_count[4] += 1
        j += 1
    if state_count[4] >= max_count:
        return float('nan')

    state_count_total = sum(state_count)
    if 5 * abs(state_count_total - ori_state_count_total) >= 2 * ori_state_count_total:
        return float('nan')
    if check_ratio(state_count) == True:
        return center_from_end(state_count, j)
    else:
        return float('nan')


# ////////////////////////////////////////////////
# ////////// CHECK DIAGONAL MEETS 1:1:3:1:1 /////
# //////////////////////////////////////////////
def cross_check_diagonal( start_i, center_j, max_count, ori_state_count_total, img ) :

    state_count = [0] * 5
    i = 0
    while start_i >= i and center_j >= i and img[start_i-i, center_j-i] < thres:
        state_count[2] += 1
        i += 1
    if start_i < i or center_j < i:
        return False
    while start_i >= i and center_j >= i and img[start_i - i, center_j - i] >= \
          thres and state_count[1] <= max_count:
        state_count[1] += 1
        i += 1
    if start_i < i or center_j < i or state_count[1] > max_count:
        return False
    while start_i >= i and center_j >= i and img[start_i - i, center_j - i] < \
          thres and state_count[0] <= max_count:
        state_count[0] += 1
        i += 1
    if state_count[0] > max_count:
        return False
    max_i = img.shape[0]
    max_j = img.shape[1]

    i = 1
    while start_i + i < max_i and center_j + i < max_j and \
            img[start_i + i, center_j + i] < thres:
        state_count[2] += 1
        i += 1
    if start_i + i >= max_i or center_j + i >= max_j:
        return False
    while start_i + i < max_i and center_j + i < max_j and \
            img[start_i + i, center_j + i] >= thres and state_count[3] < max_count:
        state_count[3] += 1
        i += 1
    if start_i + i >= max_i or center_j + i >= max_j or state_count[3] >= max_count:
        return False
    while start_i + i < max_i and center_j + i < max_j and \
            img[start_i + i, center_j + i] < thres and \
            state_count[4] < max_count:
        state_count[4] += 1
        i += 1
    if state_count[4] >= max_count:
        return False

    state_count_total = sum(state_count)
    if 5 * abs(state_count_total - ori_state_count_total) >= 2 * ori_state_count_total:
        return False
    if check_ratio(state_count) == True:
        return True
    else:
        return False


# ////////////////////////////////////////////////
# ////////// FIND THE CENTER POSITION /////
# //////////////////////////////////////////////
def center_from_end( state_count, end ):
    return end - state_count[4] - state_count[3] - state_count[2] * 0.5


# ////////////////////////////////////////////////
# ////////// CHECK WHETHER TWO FINDER ARE ABOUT EQUAL /////
# //////////////////////////////////////////////
# x is already in possible_centers
def about_equals( x, y ):
    if abs(x[0] - y[0]) <= x[2] and abs(x[1] - y[1] <= x[2]):
        if abs(x[2] - y[2]) < 1.0 or abs(x[2] - y[2]) <= x[2]:
            return True
        else:
            return False
    return False


# ////////////////////////////////////////////////
# ////////// HANDLE A POSSIBLE CENTER /////
# //////////////////////////////////////////////
def handle_possible_center( state_count, i, j, centers, img):
    state_count_total = sum(state_count)
    center_j = center_from_end(state_count, j)
    center_i = cross_check_vertical(i, int(center_j), state_count[2],
                                    state_count_total, img)
    if not math.isnan(center_i):
        center_j = cross_check_horizontal(int(center_i), int(center_j), state_count[2],
                                           state_count_total, img)
        if not math.isnan(center_j):
            if cross_check_diagonal(int(center_i), int(center_j),
                                    state_count[2], state_count_total, img):

                esitimate_module_size = state_count_total / 7.0
                found = False
                y = (center_i, center_j, esitimate_module_size)
                for x in centers:
                    if about_equals(x, y):
                        found = True
                        break
                if not found:
                    centers.append(y)


# ////////////////////////////////////////////////
# ////////// VISUALIZE THE RESULTS /////
# //////////////////////////////////////////////
def draw_color_lines( i, j, total, img, cell_size):
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

    # draw a square around the cell
    top_left_i = int(math.ceil(i - cell_size))
    top_left_j = int(math.ceil(j - cell_size))
    if top_left_i < 0:
        top_left_i = 0
    if top_left_j < 0:
        top_left_j = 0
    i = int(math.ceil(i))
    j = int(math.ceil(j))

    for x in xrange(top_left_i, i):
        img[x, top_left_j] = [255, 0, 0]
        img[x, top_left_j+1] = [255, 0, 0]
        img[x, top_left_j-1] = [255, 0, 0]
        img[x, j] = [255, 0, 0]
        img[x, j+1] = [255, 0, 0]
        img[x, j-1] = [255, 0, 0]
    for x in xrange(top_left_j, j):
        img[top_left_i, x] = [255, 0, 0]
        img[top_left_i+1, x] = [255, 0, 0]
        img[top_left_i-1, x] = [255, 0, 0]
        img[i+1, x] = [255, 0, 0]
        img[i-1, x] = [255, 0, 0]
        img[i, x] = [255, 0, 0]


# ////////////////////////////////////////////////
# ////////// CLEAR THE FINDERS /////
# //////////////////////////////////////////////
def clear_finder( i, j, ms, img ):
    start_i = int(i - ms * 4)
    end_i = int(i + ms * 4)
    start_j = int(j - ms * 4)
    end_j = int(j + ms * 4)
    for x in xrange(start_i, end_i):
        for y in xrange(start_j, end_j):
            img[x,y] = 255


# ////////////////////////////////////////////////
# ////////// COMPARE TWO POINTS /////
# //////////////////////////////////////////////
def points_cmp (p1, p2):
    if abs(p1[0] -p2[0]) < 5 * p1[2]:
        return cmp(p1[1], p2[1])
    else:
        return cmp(p1[0], p2[0])

# ////////////////////////////////////////////////
# ////////// ROTATE IMAGE and TRANSFORM THE COORDINATES/////
# //////////////////////////////////////////////
def rotate_image( possible_centers, img ):

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
    # else:
        # return False

    page_finders = [top_left, bottom_left, bottom_right]
    for i in xrange(3):
        possible_centers[i] = page_finders[i]

    ms = page_finders[0][2] * 7
    pts1 = np.float32([[page_finders[0][1],page_finders[0][0]],\
                       [page_finders[1][1],page_finders[1][0]],\
                       [page_finders[2][1],page_finders[2][0]]])
    pts2 = np.float32([[ms,ms],[ms, new_rows - ms],[new_cols - ms, new_rows - ms]])
    M = cv2.getAffineTransform(pts1, pts2)
    img = cv2.warpAffine(img, M, (new_cols, new_rows))

    for i in xrange(len(possible_centers)):
        x = np.array([possible_centers[i][1], possible_centers[i][0], 1])
        y = np.dot(M, x)
        possible_centers[i] = (y[1], y[0], possible_centers[i][2])
    return img


# ////////////////////////////////////////////////
# ////////// PARSE TEMPLATE /////
# //////////////////////////////////////////////
def parse_template( filename ):
    img = cv2.imread(filename, cv2.IMREAD_GRAYSCALE)
    old_img = cv2.imread(filename, cv2.IMREAD_COLOR)
    ret, img = cv2.threshold(img, thres, 255, cv2.THRESH_BINARY)

    # enlarge img
    # img = cv2.resize(img, None, fx=2, fy=2, interpolation = cv2.INTER_CUBIC)
    # old_img = cv2.resize(old_img, None, fx=2, fy=2, interpolation = cv2.INTER_CUBIC)
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
    ms = possible_centers[0][2] * 7
    img = rotate_image(possible_centers, img)
    possible_centers = possible_centers[:6] + sorted(possible_centers[6:], cmp=points_cmp)
    # qrcode area
    x1 = int(possible_centers[2][1] - 2 * ms)
    y1 = int(possible_centers[0][0] - ms)
    x2 = int(possible_centers[2][1] + ms)
    y2 = int(possible_centers[0][0] + 2 * ms)
    qrcode = img[y1:y2, x1:x2]
    qrdata = decode_qrcode(qrcode)
    cell_size = int(qrdata[:qrdata.find(" ")])
    print "cell size: ", cell_size
    qrdata = qrdata[qrdata.find(" ") + 1:]
    chars = []
    for char in qrdata:
        chars.append(char)

    for i in xrange(6,len(possible_centers)):
        clear_finder(possible_centers[i][0], possible_centers[i][1],
                     possible_centers[i][2], img)
        x1 = int(possible_centers[i][1] - ms)
        y1 = int(possible_centers[i][0] - ms)
        x2 = int(possible_centers[i][1])
        y2 = int(possible_centers[i][0])
        char = img[y1:y2, x1:x2]
        glyname = get_glyph_name(chars[i-6])
        print glyname,'(',chars[i-6],')'
        char = cv2.equalizeHist(char)
        cv2.imwrite(glyname + '.png', char)

    #     draw_color_lines(possible_centers[i][0], possible_centers[i][1],
    #                      possible_centers[i][2] * 7.0, old_img,
    #                      ms)
    # plt.imshow(img, cmap='gray', interpolation = 'bicubic')
    # plt.xticks([]), plt.yticks([])
    # plt.show()
    # cv2.imwrite('qrcode.png', qrcode)
    # cv2.namedWindow('image', cv2.WINDOW_AUTOSIZE)
    # cv2.imshow('image', img)
    # cv2.waitKey(0)
    # cv2.destroyAllWindows()



if __name__ == "__main__":
    parse_template(sys.argv[1])
