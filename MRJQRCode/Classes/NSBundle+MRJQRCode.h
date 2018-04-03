//
//  MRJQRCodeTool.m
//  Pods
//
//  Created by Mr on 2017/6/5.
//
//

#import <UIKit/UIKit.h>

@interface NSBundle (MRJQRCode)

/// 通过固定的宏寻找对应的资源，（国际化处理）
+ (NSString *)QRCodeLocalizedStringForKey:(NSString *)key;

+ (NSBundle *)LibraryBundle;

@end
