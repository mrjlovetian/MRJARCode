//
//  MRJ_QRCodeUtil.h
//  Pods
//
//  Created by Mr on 2017/6/23.
//
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    EncryptTypeNone = 0,///没有加密方式
    EncryptTypeBase64,///base64
    EncryptTypeRSA,///非对称加密
} EncryptType;

@interface MRJ_QRCodeUtil : NSObject

///数据加密
+ (NSData *)encryptDicWithParmStr:(NSString *)parmStr EncryptType:(EncryptType)encryptType;

///数据解密
+ (id)decodeDataWithCodeStr:(NSString *)codeStr  EncryptType:(EncryptType)encryptType;

///json格式字符串转字典：
+ (id)dictionaryWithJsonString:(NSString *)jsonString;

///字典转json格式字符串：
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/// 返回一张不超过屏幕尺寸的 image
+ (UIImage *)imageSizeWithScreenImage:(UIImage *)image;

@end
