//
//  QRCodeScanningVC.m
//  YHJQRCodeExample
//
//  Created by Mr on 2017/6/5.
//  Copyright © 2017年 余洪江. All rights reserved.
//

#import "QRCodeScanningVC.h"
#import "YHJQRCodeConst.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCodeScanningVC ()
{
    EncryptType _decodType;
}
@end

@implementation QRCodeScanningVC

- (id)initRuleDecodeType:(EncryptType)decodType State:(AuthorizationStateBlock)authorizationHander
{
    self = [super init];
    _decodType = decodType;
    if (self) {
        [self getRuleState:^(AuthorizationState state) {
            authorizationHander(state);
            if (AuthorizationStateAllowed == state) {
                // 注册观察者
                [YHJQRCodeNotificationCenter addObserver:self selector:@selector(YHJQRCodeInformationFromeAibum:) name:YHJQRCodeInformationFromeAibum object:nil];
                [YHJQRCodeNotificationCenter addObserver:self selector:@selector(YHJQRCodeInformationFromeScanning:) name:YHJQRCodeInformationFromeScanning object:nil];
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

- (void)YHJQRCodeInformationFromeAibum:(NSNotification *)noti {
    
    [self handleQRCresult:noti.object];
}

///扫码成功操作
- (void)YHJQRCodeInformationFromeScanning:(NSNotification *)noti {
//    YHJQRCodeLog(@"noti - - %@", noti);
    
    [self handleQRCresult:noti.object];
}

- (void)handleQRCresult:(id)result
{
    id resulta = [YHJQRCodeUtil decodeDataWithCodeStr:result EncryptType:_decodType];
    
    NSDictionary *qrcdic = nil;
    NSError *err = nil;
    if ([resulta isKindOfClass:[NSDictionary class]]) {
        qrcdic = resulta;
    }else if ([resulta isKindOfClass:[NSError class]])
    {
        err = resulta;
    }
    if ([self.delegate respondsToSelector:@selector(QRCodeScanningVCResult:error:)]) {
        [self.delegate QRCodeScanningVCResult:qrcdic error:err];
    }
    
    if (self.resultBlcok) {
        self.resultBlcok(qrcdic, err);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
                        authorizationHander(1);
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        QRCodeScanningVC *vc = [[QRCodeScanningVC alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                    
                    YHJQRCodeLog(@"当前线程 - - %@", [NSThread currentThread]);
                    // 用户第一次同意了访问相机权限
                    YHJQRCodeLog(@"用户第一次同意了访问相机权限");
                    
                } else {
                    if (authorizationHander) {
                        authorizationHander(2);
                    }
                    
                    // 用户第一次拒绝了访问相机权限
                    YHJQRCodeLog(@"用户第一次拒绝了访问相机权限");
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            if (authorizationHander) {
                authorizationHander(1);
            }

        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            if (authorizationHander) {
                NSLog(@"未获得权限");
                authorizationHander(2);
            }
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
            if (authorizationHander) {
                authorizationHander(3);
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
    YHJQRCodeLog(@"QRCodeScanningVC - dealloc");
    [YHJQRCodeNotificationCenter removeObserver:self];
}

@end
