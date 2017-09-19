//
//  MRJ_QRCodeUtil.m
//  Pods
//
//  Created by Mr on 2017/6/23.
//
//

#import "MRJ_QRCodeUtil.h"
#import "RSAUtil.h"
#import "MRJ_QRCodeConst.h"

@implementation MRJ_QRCodeUtil
+ (NSData *)encryptDicWithParmStr:(NSString *)parmStr EncryptType:(EncryptType)encryptType{
    NSData *resultData = nil;
    if (encryptType == EncryptTypeNone) {
        resultData = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
    }else if (encryptType == EncryptTypeBase64)
    {
        NSData *data = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
        // NSData from the Base64 encoded str
        NSData *nsdataFromBase64String = [[NSData alloc]
                                          initWithBase64EncodedString:base64Encoded options:0];
        
        NSData *nsdataFromBase64Data = [nsdataFromBase64String base64EncodedDataWithOptions:0];
        resultData = nsdataFromBase64Data;
    }else{
        NSString *string_data = [RSAUtil encryptString:parmStr publicKey:MRJ_RSA_Public_key];
        resultData = [string_data dataUsingEncoding:NSUTF8StringEncoding];
    }
    return resultData;
}

+ (id)decodeDataWithCodeStr:(NSString *)codeStr  EncryptType:(EncryptType)encryptType;{
    id result;
    
    if (encryptType == EncryptTypeNone) {
        result = [MRJ_QRCodeUtil dictionaryWithJsonString:codeStr];
        
        
    }else if (encryptType == EncryptTypeBase64)
    {
        NSData *data = [[NSData alloc]initWithBase64EncodedString:codeStr options:0];
        NSString *resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        result = [MRJ_QRCodeUtil dictionaryWithJsonString:resultStr];
        
    }else if (encryptType == EncryptTypeRSA)
    {
        NSString *resultStr = [RSAUtil decryptString:codeStr privateKey:MRJ_RSA_Privite_key];
        result = [MRJ_QRCodeUtil dictionaryWithJsonString:resultStr];
    }
    
    return result;
}

///json格式字符串转字典：
+ (id)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    if(err) {
        
        return err;
    }
    return dic;
}

///字典转json格式字符串：
+ (NSString*)dictionaryToJson:(NSDictionary *)dic{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return @"";
}


#pragma mark 图片处理
/// 返回一张不超过屏幕尺寸的 image
+ (UIImage *)imageSizeWithScreenImage:(UIImage *)image {
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat screenWidth = MRJ_QRCodeScreenWidth;
    CGFloat screenHeight = MRJ_QRCodeScreenHeight;
    
    // 如果读取的二维码照片宽和高小于屏幕尺寸，直接返回原图片
    if (imageWidth <= screenWidth && imageHeight <= screenHeight) {
        return image;
    }
    
    //MRJ_QRCodeLog(@"压缩前图片尺寸 － width：%.2f, height: %.2f", imageWidth, imageHeight);
    CGFloat max = MAX(imageWidth, imageHeight);
    // 如果是6plus等设备，比例应该是 3.0
    CGFloat scale = max / (screenHeight * 2.0f);
    //MRJ_QRCodeLog(@"压缩后图片尺寸 － width：%.2f, height: %.2f", imageWidth / scale, imageHeight / scale);
    
    return [self imageWithImage:image scaledToSize:CGSizeMake(imageWidth / scale, imageHeight / scale)];
}
/// 返回一张处理后的图片
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
