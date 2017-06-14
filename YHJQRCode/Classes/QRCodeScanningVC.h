//
//  QRCodeScanningVC.h
//  YHJQRCodeExample
//
//  Created by Mr on 2017/6/5.
//  Copyright © 2017年 余洪江. All rights reserved.
//

#import "YHJQRCodeScanningVC.h"
#import "YHJQRCode.h"

///获取相机的权限状态
typedef enum : NSUInteger {
    AuthorizationStateAllowed  =  1,
    AuthorizationStateDenied,
} AuthorizationState;

@protocol QRCodeScanningVCDelegate <NSObject>

- (void)QRCodeScanningVCResult:(id)result error:(NSError *)error;

@end

typedef void(^AuthorizationStateBlock)(AuthorizationState state);

typedef void(^QRCodeScanningVCBlock)(id result, NSError *err);

@interface QRCodeScanningVC : YHJQRCodeScanningVC

- (id)initRuleState:(AuthorizationStateBlock)authorizationHander;

@property (nonatomic, copy)QRCodeScanningVCBlock resultBlcok;

@property (nonatomic, weak)id <QRCodeScanningVCDelegate> delegate;

@end
