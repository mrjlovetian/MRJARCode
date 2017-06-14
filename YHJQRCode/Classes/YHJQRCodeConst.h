//
//  QRCViewController.m
//  YHJQRCode
//
//  Created by Mr on 2017/6/5.
//  Copyright © 2017年 余洪江. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef DEBUG
#define YHJQRCodeLog(...) NSLog(__VA_ARGS__)
#else
#define YHJQRCodeLog(...)
#endif

#define YHJQRCodeNotificationCenter [NSNotificationCenter defaultCenter]
#define YHJQRCodeScreenWidth [UIScreen mainScreen].bounds.size.width
#define YHJQRCodeScreenHeight [UIScreen mainScreen].bounds.size.height

/** 二维码冲击波动画时间 */
UIKIT_EXTERN CGFloat const YHJQRCodeScanningLineAnimation;

/** 扫描得到的二维码信息 */
UIKIT_EXTERN NSString *const YHJQRCodeInformationFromeScanning;

/** 从相册里得到的二维码信息 */
UIKIT_EXTERN NSString *const YHJQRCodeInformationFromeAibum;

///公钥
UIKIT_EXTERN NSString *const YHJRSA_Public_key;

///私钥
UIKIT_EXTERN NSString *const YHJRSA_Privite_key;
