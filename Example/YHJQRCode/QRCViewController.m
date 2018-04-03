//
//  QRCViewController.m
//  KKQRCode
//
//  Created by Mr on 2017/6/5.
//  Copyright © 2017年 余洪江. All rights reserved.
//

#import "QRCViewController.h"
#import "MRJQRCode.h"
#import "QRCodeScanningVC.h"

@interface QRCViewController ()<QRCodeScanningVCDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *codeView;


@end

@implementation QRCViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)qrcode:(id)sender {
    QRCodeScanningVC *vc = [[QRCodeScanningVC alloc] initRuleDecodeType:EncryptTypeNone State:^(AuthorizationState state) {
        if (state == AuthorizationStateDenied) {
            NSLog(@"哦吼，获取相机的权限被拒绝了！！！");
        }
    }];
    vc.resultBlcok = ^(id result, NSError *err, UIViewController *vc) {
        NSLog(@"-=-=-==%@-=-=-=-=%@", result, err);
    };
    
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)genderCode:(id)sender {
    NSDictionary *dic = @{@"name":@"mrjnumber", @"id":@"89701180595270098976", @"number":@"15757184409876sdfdhdbgd"};
    self.codeView.image = [MRJQRCodeTool MRJgenerateWithDefaultQRCodeData:dic imageViewWidth:240.0 encryptType:EncryptTypeNone errorHandle:^(NSString *err) {
        
    }];
    self.codeView.image = [MRJQRCodeTool MRJgenerateWithLogoQRCodeData:dic logoImageName:@"share_kber" logoScaleToSuperView:0.1 encryptType:EncryptTypeNone errorHandle:^(NSString *err) {
        
    }];
    

    
    // 2、将二维码显示在UIImageView上
//    UIImage *image = [MRJQRCodeTool MRJgenerateWithColorQRCodeData:dic backgroundColor:[CIColor whiteColor] mainColor:[CIColor colorWithRed:0.3 green:0.2 blue:0.4]];
//    self.codeView.image = image;
}

#pragma mark QRCodeScanningVCDelegate
- (void)QRCodeScanningVCResult:(id)result error:(NSError *)error qrc:(UIViewController *)vc
{
//    NSLog(@"********%@************%@", result, error);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
