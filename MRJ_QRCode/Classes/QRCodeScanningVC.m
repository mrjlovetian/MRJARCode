//
//  QRCodeScanningVC.m
//  MRJ_QRCodeExample
//
//  Created by Mr on 2017/6/5.
//  Copyright © 2017年 余洪江. All rights reserved.
//

#import "QRCodeScanningVC.h"
#import "MRJ_QRCodeConst.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCodeScanningVC (){
    
    EncryptType _decodType;
}
@end

@implementation QRCodeScanningVC

- (id)initRuleDecodeType:(EncryptType)decodType State:(AuthorizationStateBlock)authorizationHander{
    self = [super init];
    _decodType = decodType;
    if (self) {
        [self getRuleState:^(AuthorizationState state) {
            authorizationHander(state);
            if (AuthorizationStateAllowed == state) {
                // 注册观察者
                [MRJ_QRCodeNotificationCenter addObserver:self selector:@selector(MRJ_QRCodeInformationFromeAibum:) name:MRJ_QRCodeInformationFromeAibum object:nil];
                [MRJ_QRCodeNotificationCenter addObserver:self selector:@selector(MRJ_QRCodeInformationFromeScanning:) name:MRJ_QRCodeInformationFromeScanning object:nil];
            }else
            {
                NSLog(@"这是未获得状态");
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

- (void)MRJ_QRCodeInformationFromeAibum:(NSNotification *)noti {
    
    [self handleQRCresult:noti.object];
}

///扫码成功操作
- (void)MRJ_QRCodeInformationFromeScanning:(NSNotification *)noti {
//    MRJ_QRCodeLog(@"noti - - %@", noti);
    
    [self handleQRCresult:noti.object];
}

- (void)handleQRCresult:(id)result
{
    NSDictionary *qrcdic = nil;
    NSError *err = nil;
    id resulta = [MRJ_QRCodeUtil decodeDataWithCodeStr:result EncryptType:_decodType];
    if ([result integerValue] == -1) {
        err = [[NSError alloc] initWithDomain:@"error image core" code:-1 userInfo:nil];
    }else
    {
        if ([resulta isKindOfClass:[NSDictionary class]]) {
            qrcdic = resulta;
        }else if ([resulta isKindOfClass:[NSError class]])
        {
            err = resulta;
        }
    }
    if ([self.delegate respondsToSelector:@selector(QRCodeScanningVCResult:error:qrc:)]) {
        [self.delegate QRCodeScanningVCResult:qrcdic error:err qrc:self];
    }
    
    if (self.resultBlcok) {
        self.resultBlcok(qrcdic, err, self);
    }
    
}

- (void)getRuleState:(AuthorizationStateBlock)authorizationHander
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    if (authorizationHander) {
                        authorizationHander(AuthorizationStateAllowed);
                    }
                    
                    MRJ_QRCodeLog(@"当前线程 - - %@", [NSThread currentThread]);
                    // 用户第一次同意了访问相机权限
                    MRJ_QRCodeLog(@"用户第一次同意了访问相机权限");
                    
                } else {
                    if (authorizationHander) {
                        authorizationHander(AuthorizationStateDenied);
                    }
                    
                    // 用户第一次拒绝了访问相机权限
                    MRJ_QRCodeLog(@"用户第一次拒绝了访问相机权限");
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            if (authorizationHander) {
                authorizationHander(AuthorizationStateAllowed);
            }

        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            if (authorizationHander) {
                NSLog(@"未获得权限");
                authorizationHander(AuthorizationStateDenied);
            }
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
            if (authorizationHander) {
                authorizationHander(AuthorizationStateAlbumDenied);
            }
        }
    } else {
//        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
//        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        
//        [alertC addAction:alertA];
//        [self presentViewController:alertC animated:YES completion:nil];
    }
}

- (void)dealloc {
    MRJ_QRCodeLog(@"QRCodeScanningVC - dealloc");
    [MRJ_QRCodeNotificationCenter removeObserver:self];
}

@end
