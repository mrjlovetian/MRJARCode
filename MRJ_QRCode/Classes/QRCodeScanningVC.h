//
//  QRCodeScanningVC.h
//  MRJ_QRCodeExample
//
//  Created by Mr on 2017/6/5.
//  Copyright © 2017年 余洪江. All rights reserved.
//

#import "MRJ_QRCodeScanningVC.h"
#import "MRJ_QRCode.h"

///获取相机的权限状态
typedef enum : NSUInteger {
    AuthorizationStateAllowed  =  1,
    AuthorizationStateDenied,
    AuthorizationStateAlbumDenied
} AuthorizationState;

@protocol QRCodeScanningVCDelegate <NSObject>

- (void)QRCodeScanningVCResult:(id)result error:(NSError *)error qrc:(UIViewController *)vc;

@end

///获取验证状态
typedef void(^AuthorizationStateBlock)(AuthorizationState state);

///扫码结果返回
typedef void(^QRCodeScanningVCBlock)(id result, NSError *err, UIViewController *vc);

@interface QRCodeScanningVC : MRJ_QRCodeScanningVC

///初始化方法
- (id)initRuleDecodeType:(EncryptType)decodType State:(AuthorizationStateBlock)authorizationHander;

///结果回调
@property (nonatomic, copy)QRCodeScanningVCBlock resultBlcok;

///扫码代理方法
@property (nonatomic, weak)id <QRCodeScanningVCDelegate> delegate;

@end
