//
//  QRCViewController.m
//  MRJ_QRCode
//
//  Created by Mr on 2017/6/5.
//  Copyright © 2017年 余洪江. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef DEBUG
#define MRJ_QRCodeLog(...) NSLog(__VA_ARGS__)
#else
#define MRJ_QRCodeLog(...)
#endif

#define MRJ_QRCodeNotificationCenter [NSNotificationCenter defaultCenter]
#define MRJ_QRCodeScreenWidth [UIScreen mainScreen].bounds.size.width
#define MRJ_QRCodeScreenHeight [UIScreen mainScreen].bounds.size.height

/** 二维码冲击波动画时间 */
UIKIT_EXTERN CGFloat const MRJ_QRCodeScanningLineAnimation;

/** 扫描得到的二维码信息 */
UIKIT_EXTERN NSString *const MRJ_QRCodeInformationFromeScanning;

/** 从相册里得到的二维码信息 */
UIKIT_EXTERN NSString *const MRJ_QRCodeInformationFromeAibum;

///公钥
UIKIT_EXTERN NSString *const MRJ_RSA_Public_key;

///私钥
UIKIT_EXTERN NSString *const MRJ_RSA_Privite_key;

///國際化
UIKIT_EXTERN NSString *const MRJ_QRCodeMessage;
UIKIT_EXTERN NSString *const MRJ_QRCodeTeachOpen;
UIKIT_EXTERN NSString *const MRJ_QRCodeSure;
UIKIT_EXTERN NSString *const MRJ_QRCodeLikeMessage;
UIKIT_EXTERN NSString *const MRJ_QRCodeDefinePhoto;
UIKIT_EXTERN NSString *const MRJ_QRCodeScaning;
UIKIT_EXTERN NSString *const MRJ_QRCodeOpenLight;
UIKIT_EXTERN NSString *const MRJ_QRCodeCloseLight;
UIKIT_EXTERN NSString *const MRJ_QRCodeDataError;
UIKIT_EXTERN NSString *const MRJ_QRCodeWidthError;
UIKIT_EXTERN NSString *const MRJ_QRCodeLogoImageError;
UIKIT_EXTERN NSString *const MRJ_QRCodeLogoScaleError;
UIKIT_EXTERN NSString *const MRJ_QRCodeChongqingjzb;
UIKIT_EXTERN NSString *const MRJ_QRCodeAlbum;
