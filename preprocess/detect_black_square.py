import cv2
import numpy as np

frame=cv2.imread('squares.jpg')
img=cv2.GaussianBlur(frame, (5,5), 0)

img=cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

upper=np.array([180, 255, 50],np.uint8)
lower=np.array([0, 0, 0],np.uint8)
separated=cv2.inRange(img,lower,upper)


#this bit draws a red rectangle around the detected region
contours,hierarchy=cv2.findContours(separated,cv2.RETR_LIST,cv2.CHAIN_APPROX_SIMPLE)
max_area = 0
largest_contour = None
for idx, contour in enumerate(contours):
    area = cv2.contourArea(contour)
    if area > max_area:
        max_area = area
        largest_contour=contour
        if not largest_contour==None:
            moment = cv2.moments(largest_contour)
            if moment["m00"] > 1000:
                rect = cv2.minAreaRect(largest_contour)
                rect = ((rect[0][0], rect[0][1]), (rect[1][0], rect[1][1]), rect[2])
                (width,height)=(rect[1][0],rect[1][1])
                print str(width)+" "+str(height)
                box = cv2.cv.BoxPoints(rect)
                box = np.int0(box)
                if(height>0.9*width and height<1.1*width):
                    cv2.drawContours(frame,[box], 0, (0, 0, 255), 2)

cv2.imshow('img',frame)
k = cv2.waitKey(0) & 0xFF
if k == 27:
    cv2.destroyAllWindows()
