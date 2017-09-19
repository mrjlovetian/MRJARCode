//
//  MRJ_QRCodeTool.m
//  Pods
//
//  Created by Mr on 2017/6/5.
//
//

#import "NSBundle+MRJ_QRCode.h"
#import "MRJ_QRCodeScanningView.h"

@implementation NSBundle (MRJ_QRCode)
+ (NSString *)mrj_QRCodeLocalizedStringForKey:(NSString *)key{
    return [self mrj_QRCodeLocalizedStringForKey:key value:nil];
}

+ (NSString *)mrj_QRCodeLocalizedStringForKey:(NSString *)key value:(NSString *)value{
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
    
    bundle = [NSBundle bundleWithPath:[[self mrj_LibraryBundle] pathForResource:language ofType:@"lproj"]];
    return [bundle localizedStringForKey:key value:value table:nil];
}

///加载pod资源相关资料
///http://blog.xianqu.org/2015/08/pod-resources/
+ (NSBundle *)mrj_LibraryBundle {
    return [self bundleWithURL:[self mrj_myLibraryBundleURL]];
}

+ (NSURL *)mrj_myLibraryBundleURL {
    NSBundle *bundle = [NSBundle bundleForClass:[MRJ_QRCodeScanningView class]];
    return [bundle URLForResource:@"MRJ_QRCode" withExtension:@"bundle"];
}

@end
