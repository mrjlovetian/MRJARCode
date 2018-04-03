//
//  MRJQRCodeTool.m
//  Pods
//
//  Created by Mr on 2017/6/5.
//
//

#import "NSBundle+MRJQRCode.h"
#import "MRJQRCodeScanningView.h"

@implementation NSBundle (MRJQRCode)

+ (NSString *)QRCodeLocalizedStringForKey:(NSString *)key {
    return [self QRCodeLocalizedStringForKey:key value:nil];
}

+ (NSString *)QRCodeLocalizedStringForKey:(NSString *)key value:(NSString *)value {
    NSBundle *bundle = nil;
    // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
    NSString *language = [NSLocale preferredLanguages].firstObject;
    if ([language hasPrefix:@"en"]) {
        language = @"en";
    } else if ([language hasPrefix:@"zh"]) {
        if ([language rangeOfString:@"Hans"].location != NSNotFound) {
            language = @"zh-Hans"; // 简体中文
        } else { // zh-Hant\zh-HK\zh-TW
            language = @"zh-Hant"; // 繁體中文
        }
    } else {
        language = @"en";
    }
    bundle = [NSBundle bundleWithPath:[[self LibraryBundle] pathForResource:language ofType:@"lproj"]];
    return [bundle localizedStringForKey:key value:value table:nil];
}

/// 加载pod资源相关资料
///http://blog.xianqu.org/2015/08/pod-resources/
+ (NSBundle *)LibraryBundle {
    return [self bundleWithURL:[self myLibraryBundleURL]];
}

+ (NSURL *)myLibraryBundleURL {
    NSBundle *bundle = [NSBundle bundleForClass:[MRJQRCodeScanningView class]];
    return [bundle URLForResource:@"MRJQRCode" withExtension:@"bundle"];
}

@end
