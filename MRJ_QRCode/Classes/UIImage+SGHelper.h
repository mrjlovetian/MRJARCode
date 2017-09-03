//
//  UIImage+SGHelper.h
//  MRJ_QRCodeExample
//
//  Created by Mr on 2017/6/5.
//  Copyright © 2017年 余洪江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SGHelper)
/** 返回一张不超过屏幕尺寸的 image */
+ (UIImage *)imageSizeWithScreenImage:(UIImage *)image;

@end
