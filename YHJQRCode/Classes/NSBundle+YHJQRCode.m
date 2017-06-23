//
//  YHJQRCodeTool.m
//  Pods
//
//  Created by Mr on 2017/6/5.
//
//

#import "NSBundle+YHJQRCode.h"
//#import "YHJQRCodeUtil.h"

@implementation NSBundle (YHJQRCode)
+ (NSString *)YHJQRCodeLocalizedStringForKey:(NSString *)key
{
    return [self YHJQRCodeLocalizedStringForKey:key value:nil];
}

+ (NSString *)YHJQRCodeLocalizedStringForKey:(NSString *)key value:(NSString *)value
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
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
        
        bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj" inDirectory:@"YHJQRCode.bundle"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}
@end
