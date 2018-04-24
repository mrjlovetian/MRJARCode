//
//  QRCViewController.m
//  MRJQRCode
//
//  Created by Mr on 2017/6/5.
//  Copyright © 2017年 余洪江. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef DEBUG
#define MRJQRCodeLog(...) NSLog(__VA_ARGS__)
#else
#define MRJQRCodeLog(...)
#endif

#define MRJQRCodeNotificationCenter [NSNotificationCenter defaultCenter]
#define MRJQRCodeScreenWidth [UIScreen mainScreen].bounds.size.width
#define MRJQRCodeScreenHeight [UIScreen mainScreen].bounds.size.height

/// 二维码冲击波动画时间
UIKIT_EXTERN CGFloat const MRJQRCodeScanningLineAnimation;

/// 扫描得到的二维码信息
UIKIT_EXTERN NSString *const MRJQRCodeInformationFromeScanning;

/// 从相册里得到的二维码信息
UIKIT_EXTERN NSString *const MRJQRCodeInformationFromeAibum;

/// 公钥
UIKIT_EXTERN NSString *const MRJRSA_Public_key;

/// 私钥
UIKIT_EXTERN NSString *const MRJRSA_Privite_key;

/// 國際化
UIKIT_EXTERN NSString *const MRJQRCodeMessage;
UIKIT_EXTERN NSString *const MRJQRCodeTeachOpen;
UIKIT_EXTERN NSString *const MRJQRCodeSure;
UIKIT_EXTERN NSString *const MRJQRCodeLikeMessage;
UIKIT_EXTERN NSString *const MRJQRCodeDefinePhoto;
UIKIT_EXTERN NSString *const MRJQRCodeScaning;
UIKIT_EXTERN NSString *const MRJQRCodeOpenLight;
UIKIT_EXTERN NSString *const MRJQRCodeCloseLight;
UIKIT_EXTERN NSString *const MRJQRCodeDataError;
UIKIT_EXTERN NSString *const MRJQRCodeWidthError;
UIKIT_EXTERN NSString *const MRJQRCodeLogoImageError;
UIKIT_EXTERN NSString *const MRJQRCodeLogoScaleError;
UIKIT_EXTERN NSString *const MRJQRCodeChongqingjzb;
UIKIT_EXTERN NSString *const MRJQRCodeAlbum;
