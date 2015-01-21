import numpy as np
import cv2
from matplotlib import pyplot as plt
import sys

img = cv2.imread(sys.argv[1])

dst = cv2.fastNlMeansDenoisingColored(img,None,10,10,7,21)

plt.subplot(121),plt.imshow(img)
plt.subplot(122),plt.imshow(dst)
plt.show()
