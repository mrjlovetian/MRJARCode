//
//  MRJ_QRCodeTool.h
//  Pods
//
//  Created by Mr on 2017/6/5.
//
//

#import <UIKit/UIKit.h>
#import "MRJ_QRCodeUtil.h"

typedef void(^ErrorHandle)(NSString *err);

@interface MRJ_QRCodeTool : NSObject
/** 生成一张普通的二维码 */
+ (UIImage *)MRJ_generateWithDefaultQRCodeData:(NSDictionary *)dataDic imageViewWidth:(CGFloat)imageViewWidth encryptType:(EncryptType)encryptType errorHandle:(ErrorHandle)errorHandle;

/** 生成一张带有logo的二维码（logoScaleToSuperView：相对于父视图的缩放比取值范围0-1；0，不显示，1，代表与父视图大小相同） */
+ (UIImage *)MRJ_generateWithLogoQRCodeData:(NSDictionary *)dataDic logoImageName:(NSString *)logoImageName logoScaleToSuperView:(CGFloat)logoScaleToSuperView encryptType:(EncryptType)encryptType errorHandle:(ErrorHandle)errorHandle;

/** 生成一张彩色的二维码 */
//+ (UIImage *)MRJ_generateWithColorQRCodeData:(NSDictionary *)dataDic backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor;


@end
