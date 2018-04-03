//
//  QRCodeScanningVC.m
//  MRJQRCodeExample
//
//  Created by Mr on 2017/6/5.
//  Copyright © 2017年 余洪江. All rights reserved.
//

#import "QRCodeScanningVC.h"
#import "MRJQRCodeConst.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCodeScanningVC () {
    EncryptType _decodType;
}

@end

@implementation QRCodeScanningVC

- (id)initRuleDecodeType:(EncryptType)decodType State:(AuthorizationStateBlock)authorizationHander {
    self = [super init];
    _decodType = decodType;
    if (self) {
        [self getRuleState:^(AuthorizationState state) {
            authorizationHander(state);
            if (AuthorizationStateAllowed == state) {
                // 注册观察者
                [MRJQRCodeNotificationCenter addObserver:self selector:@selector(MRJQRCodeInformationFromeAibum:) name:MRJQRCodeInformationFromeAibum object:nil];
                [MRJQRCodeNotificationCenter addObserver:self selector:@selector(MRJQRCodeInformationFromeScanning:) name:MRJQRCodeInformationFromeScanning object:nil];
            } else {
                MRJQRCodeLog(@"这是未获得状态");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                });
            }
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)MRJQRCodeInformationFromeAibum:(NSNotification *)noti {
    [self handleQRCresult:noti.object];
}

/// 扫码成功操作
- (void)MRJQRCodeInformationFromeScanning:(NSNotification *)noti {
    [self handleQRCresult:noti.object];
}

- (void)handleQRCresult:(id)result {
    NSDictionary *qrcdic = nil;
    NSError *err = nil;
    id resulta = [MRJQRCodeUtil decodeDataWithCodeStr:result EncryptType:_decodType];
    if ([result integerValue] == -1) {
        err = [[NSError alloc] initWithDomain:@"error image core" code:-1 userInfo:nil];
    } else {
        if ([resulta isKindOfClass:[NSError class]]) {
            err = resulta;
        } else {
            qrcdic = resulta;
        }
    }
    if ([self.delegate respondsToSelector:@selector(QRCodeScanningVCResult:error:qrc:)]) {
        [self.delegate QRCodeScanningVCResult:qrcdic error:err qrc:self];
    }
    if (self.resultBlcok) {
        self.resultBlcok(qrcdic, err, self);
    }
}

- (void)getRuleState:(AuthorizationStateBlock)authorizationHander {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    if (authorizationHander) {
                        authorizationHander(AuthorizationStateAllowed);
                    }
                    MRJQRCodeLog(@"当前线程 - - %@", [NSThread currentThread]);
                    // 用户第一次同意了访问相机权限
                    MRJQRCodeLog(@"用户第一次同意了访问相机权限");
                } else {
                    if (authorizationHander) {
                        authorizationHander(AuthorizationStateDenied);
                    }
                    // 用户第一次拒绝了访问相机权限
                    MRJQRCodeLog(@"用户第一次拒绝了访问相机权限");
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            if (authorizationHander) {
                authorizationHander(AuthorizationStateAllowed);
            }
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            if (authorizationHander) {
                MRJQRCodeLog(@"未获得权限");
                authorizationHander(AuthorizationStateDenied);
            }
        } else if (status == AVAuthorizationStatusRestricted) {
            MRJQRCodeLog(@"因为系统原因, 无法访问相册");
            if (authorizationHander) {
                authorizationHander(AuthorizationStateAlbumDenied);
            }
        }
    } else {
        MRJQRCodeLog(@"未检测到您的摄像头");
    }
}

- (void)dealloc {
    MRJQRCodeLog(@"QRCodeScanningVC - dealloc");
    [MRJQRCodeNotificationCenter removeObserver:self];
}

@end
