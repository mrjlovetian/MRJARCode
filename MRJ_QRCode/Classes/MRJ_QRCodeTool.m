//
//  MRJ_QRCodeTool.m
//  Pods
//
//  Created by Mr on 2017/6/5.
//
//

#import "MRJ_QRCodeTool.h"
#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>
#import "RSAUtil.h"
#import "MRJ_QRCodeConst.h"
#import "NSBundle+MRJ_QRCode.h"

@implementation MRJ_QRCodeTool
/**
 *  生成一张普通的二维码
 *
 *  @param dataDic    传入你要生成二维码的数据
 *  @param imageViewWidth    图片的宽度
 */
+ (UIImage *)MRJ_generateWithDefaultQRCodeData:(NSDictionary *)dataDic imageViewWidth:(CGFloat)imageViewWidth encryptType:(EncryptType)encryptType errorHandle:(ErrorHandle)errorHandle{
    
    if (![self verifyDicValid:dataDic]) {
        errorHandle([NSBundle mrj_QRCodeLocalizedStringForKey:MRJ_QRCodeDataError]);
        return nil;
    }
    
    if (![self verifyCodeWidth:imageViewWidth]) {
        errorHandle([NSBundle mrj_QRCodeLocalizedStringForKey:MRJ_QRCodeWidthError]);
        return nil;
    }
    
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *info = [MRJ_QRCodeUtil dictionaryToJson:dataDic];//data;
    // 将字符串转换成
    NSData *infoData = [MRJ_QRCodeUtil encryptDicWithParmStr:info EncryptType:encryptType];
    
    // 通过KVC设置滤镜inputMessage数据
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    
    return [MRJ_QRCodeTool createNonInterpolatedUIImageFormCIImage:outputImage withSize:imageViewWidth];
}

/** 根据CIImage生成指定大小的UIImage */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

/**
 *  生成一张带有logo的二维码
 *
 *  @param dataDic    传入你要生成二维码的数据
 *  @param logoImageName    logo的image名
 *  @param logoScaleToSuperView    logo相对于父视图的缩放比（取值范围：0-1，0，代表不显示，1，代表与父视图大小相同）
 */
+ (UIImage *)MRJ_generateWithLogoQRCodeData:(NSDictionary *)dataDic logoImageName:(NSString *)logoImageName logoScaleToSuperView:(CGFloat)logoScaleToSuperView encryptType:(EncryptType)encryptType errorHandle:(ErrorHandle)errorHandle{
    
    if (![self verifyLogoImageValid:logoImageName]) {
        errorHandle([NSBundle mrj_QRCodeLocalizedStringForKey:MRJ_QRCodeLogoImageError]);
        return nil;
    }
    
    if (![self verifyLogoScale:logoScaleToSuperView]) {
        errorHandle([NSBundle mrj_QRCodeLocalizedStringForKey:MRJ_QRCodeLogoScaleError]);
        return nil;
    }
    
    if (![self verifyDicValid:dataDic]) {
        errorHandle([NSBundle mrj_QRCodeLocalizedStringForKey:MRJ_QRCodeDataError]);
        return nil;
    }
    
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *string_data = [MRJ_QRCodeUtil dictionaryToJson:dataDic];//data;
    // 将字符串转换成 NSdata (虽然二维码本质上是字符串, 但是这里需要转换, 不转换就崩溃)
    NSData *qrImageData = [MRJ_QRCodeUtil encryptDicWithParmStr:string_data EncryptType:encryptType];
    
    // 设置过滤器的输入值, KVC赋值
    [filter setValue:qrImageData forKey:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(3, 3)];
    
    // 4、将CIImage类型转成UIImage类型
    UIImage *start_image = [UIImage imageWithCIImage:outputImage];
    
    
    // - - - - - - - - - - - - - - - - 添加中间小图标 - - - - - - - - - - - - - - - -
    // 5、开启绘图, 获取图形上下文 (上下文的大小, 就是二维码的大小)
    UIGraphicsBeginImageContext(start_image.size);
    
    // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
    [start_image drawInRect:CGRectMake(0, 0, start_image.size.width, start_image.size.height)];
    
    // 再把小图片画上去
    NSString *icon_imageName = logoImageName;
    UIImage *icon_image = [UIImage imageNamed:icon_imageName];
    CGFloat icon_imageW = start_image.size.width * logoScaleToSuperView;
    CGFloat icon_imageH = start_image.size.height * logoScaleToSuperView;
    CGFloat icon_imageX = (start_image.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (start_image.size.height - icon_imageH) * 0.5;
    
    [icon_image drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    
    // 6、获取当前画得的这张图片
    UIImage *final_image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 7、关闭图形上下文
    UIGraphicsEndImageContext();
    
    return final_image;
}

/**
 *  生成一张彩色的二维码
 *
 *  @param dataDic    传入你要生成二维码的数据
 *  @param backgroundColor    背景色
 *  @param mainColor    主颜色
 */
+ (UIImage *)MRJ_generateWithColorQRCodeData:(NSDictionary *)dataDic backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor {
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *string_data = [RSAUtil encryptString:[MRJ_QRCodeUtil dictionaryToJson:dataDic] publicKey:MRJ_RSA_Public_key];//data
    // 将字符串转换成 NSdata (虽然二维码本质上是字符串, 但是这里需要转换, 不转换就崩溃)
    NSData *qrImageData = [string_data dataUsingEncoding:NSUTF8StringEncoding];
    
    // 设置过滤器的输入值, KVC赋值
    [filter setValue:qrImageData forKey:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(9, 9)];
    
    
    // 4、创建彩色过滤器(彩色的用的不多)
    CIFilter * color_filter = [CIFilter filterWithName:@"CIFalseColor"];
    
    // 设置默认值
    [color_filter setDefaults];
    
    // 5、KVC 给私有属性赋值
    [color_filter setValue:outputImage forKey:@"inputImage"];
    
    // 6、需要使用 CIColor
    [color_filter setValue:backgroundColor forKey:@"inputColor0"];
    [color_filter setValue:mainColor forKey:@"inputColor1"];
    
    // 7、设置输出
    CIImage *colorImage = [color_filter outputImage];
    
    return [UIImage imageWithCIImage:colorImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}

///判断传入的数据是否为有效的参数
+ (BOOL)verifyDicValid:(id)parmater{
    if ([parmater isKindOfClass:[NSDictionary class]]) {
        return YES;
    }else
    {
        NSLog(@"error 请传入有效的数据格式dic");
        return NO;
    }
}

///判断二维码宽度有效性
+ (BOOL)verifyCodeWidth:(CGFloat)codeWidth{
    if (codeWidth > 0 && codeWidth < [UIScreen mainScreen].bounds.size.width) {
        return YES;
    }else
    {
        NSLog(@"error 生成二维码的图片大小超出范围");
        return NO;
    }
}

///判断图片的有效性
+ (BOOL)verifyLogoImageValid:(id)logoImage{
    if ([logoImage isKindOfClass:[UIImage class]]) {
        return YES;
    }else
    {
        NSLog(@"error 请传入有效的图片 image");
        return NO;
    }
}

///logo比例大小
+ (BOOL)verifyLogoScale:(CGFloat)ogoScale{
    if (ogoScale > 0 && ogoScale < 0.5) {
        return YES;
    }else
    {
        NSLog(@"error logo大小超出有效范围");
        return NO;
    }
}

@end
