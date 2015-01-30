import numpy as np
import cv2

import sys

img = cv2.imread(sys.argv[1], cv2.IMREAD_COLOR)
res = cv2.resize(img, None, fx=2, fy=2, interpolation = cv2.INTER_CUBIC)
cv2.imwrite('haha.png', res)
