//
//  OpenCV.h
//  Alyssa
//
//  Created by Wenzheng Li on 10/13/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

#ifndef OpenCV_h
#define OpenCV_h

#import <UIKit/UIKit.h>

@interface OpenCV : NSObject

/// Converts a full color image to purified image with using OpenCV.
+ (UIImage *)magicallyExtractChar:(UIImage *)image;
+ (UIImage *)invertImage:(UIImage *)image;
@end

#endif /* OpenCV_h */
