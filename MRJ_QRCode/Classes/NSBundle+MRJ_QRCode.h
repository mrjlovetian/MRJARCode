//
//  MRJ_QRCodeTool.m
//  Pods
//
//  Created by Mr on 2017/6/5.
//
//

#import <UIKit/UIKit.h>

@interface NSBundle (MRJ_QRCode)

///通过固定的宏寻找对应的资源，（国际化处理）
+ (NSString *)mrj_QRCodeLocalizedStringForKey:(NSString *)key;

+ (NSBundle *)mrj_LibraryBundle;

@end
