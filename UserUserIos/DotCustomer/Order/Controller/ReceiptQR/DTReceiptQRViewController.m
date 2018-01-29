//
//  DTReceiptQRViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTReceiptQRViewController.h"
#import "SGQRCode.h"
#import "DTRedPacketViewController.h"

@interface DTReceiptQRViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (strong, nonatomic) UIImage *qrImage;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation DTReceiptQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"团购券";

    self.saveBtn.layer.cornerRadius = 24.5;
    self.saveBtn.layer.masksToBounds = true;
    self.saveBtn.layer.borderColor = RGB(246, 30, 46).CGColor;
    self.saveBtn.layer.borderWidth = 1;
    
    [self loadData];
    weakSelf(self);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3
                                                  target:weakSelf selector:@selector(getOrderStatus) userInfo:nil repeats:true];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:orderPayCode]
                             headParams:param
                             bodyParams:@{@"orderNo" : self.orderNo}
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    [ShowMessage showMessage:responseObject[@"msg"]];
                                    if ([responseObject[@"status"] integerValue] == 1) {
                                        
                                        self.qrImage = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:responseObject[@"data"][@"code"] imageViewWidth:200];
                                        self.qrcodeImageView.image = self.qrImage;
                                        [self.saveBtn setTitle:responseObject[@"data"][@"code"] forState:UIControlStateNormal];
                                    }
                                }
                                failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    [ShowMessage showMessage:error.description];
                                    [MBProgressHUD hideHUDForView:self.view];
                                }];
}

- (void)getOrderStatus {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getOrderStatus]
                             headParams:param
                             bodyParams:@{@"orderNo" : self.orderNo}
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    [ShowMessage showMessage:responseObject[@"msg"]];
                                    if ([responseObject[@"status"] integerValue] == 1) {
                                        if ([responseObject[@"data"][@"status"] integerValue] == 2) {
                                            [ShowMessage showMessage:@"核销成功"];
                                            [self.timer invalidate];
                                            self.timer = nil;
                                            
                                            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationOrderUseSuccess object:nil userInfo:nil];
                                            
                                            [self getRedPacketNum];
                                        }
                                    }
                                }
                                failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    [ShowMessage showMessage:error.description];
                                    [MBProgressHUD hideHUDForView:self.view];
                                }];
}

- (void)getRedPacketNum {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getRedPacket]
                             headParams:param
                             bodyParams:@{@"orderNo" : self.orderNo}
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];

                                    if ([responseObject[@"status"] integerValue] == 1) {
                                        if ([responseObject[@"data"] floatValue] > 0.0) {
                                            DTRedPacketViewController *vwcRed = [[DTRedPacketViewController alloc] initWithNibName:NSStringFromClass([DTRedPacketViewController class]) bundle:[NSBundle mainBundle]];
                                            vwcRed.model = self.model;
                                            vwcRed.redpacketNum = responseObject[@"data"];
                                            [self.navigationController pushViewController:vwcRed animated:true];
                                        } else {
                                            [self.navigationController popToRootViewControllerAnimated:true];
                                        }
                                    }
                                }
                                failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    [ShowMessage showMessage:error.description];
                                    [MBProgressHUD hideHUDForView:self.view];
                                }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchSavaBtn:(id)sender {
//    [self loadImageFinished:self.qrImage];
}

- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [MBProgressHUD showSuccess:@"保存成功"];
    } else {
        [MBProgressHUD showError:@"保存失败"];
    }
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}


@end
