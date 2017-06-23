//
//  YHJQRCodeUtil.m
//  Pods
//
//  Created by Mr on 2017/6/23.
//
//

#import "YHJQRCodeUtil.h"
#import "RSAUtil.h"
#import "YHJQRCodeConst.h"

@implementation YHJQRCodeUtil
+ (NSData *)encryptDicWithParmStr:(NSString *)parmStr EncryptType:(EncryptType)encryptType
{
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
        NSString *string_data = [RSAUtil encryptString:parmStr publicKey:YHJRSA_Public_key];
        resultData = [string_data dataUsingEncoding:NSUTF8StringEncoding];
    }
    return resultData;
}

+ (id)decodeDataWithCodeStr:(NSString *)codeStr  EncryptType:(EncryptType)encryptType;
{
    id result;
    
    if (encryptType == EncryptTypeNone) {
        result = [YHJQRCodeUtil dictionaryWithJsonString:codeStr];
        
        
    }else if (encryptType == EncryptTypeBase64)
    {
        NSData *data = [[NSData alloc]initWithBase64EncodedString:codeStr options:0];
        NSString *resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        result = [YHJQRCodeUtil dictionaryWithJsonString:resultStr];
        
    }else if (encryptType == EncryptTypeRSA)
    {
        NSString *resultStr = [RSAUtil decryptString:codeStr privateKey:YHJRSA_Privite_key];
        result = [YHJQRCodeUtil dictionaryWithJsonString:resultStr];
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
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return @"";
}

@end
