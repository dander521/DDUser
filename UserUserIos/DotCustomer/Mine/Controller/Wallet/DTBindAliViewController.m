//
//  DTBindAliViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTBindAliViewController.h"

@interface DTBindAliViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *alipayTF;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
@property (weak, nonatomic) IBOutlet UIView *pincodeView;
@property (weak, nonatomic) IBOutlet UITextField *pincodeTF;
@property (weak, nonatomic) IBOutlet UIButton *getPinBtn;

@end

@implementation DTBindAliViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.getPinBtn.layer.cornerRadius = 15;
    self.getPinBtn.layer.masksToBounds = true;
    
    if (self.isBind) {
        self.navigationItem.title = @"支付宝解绑";
        self.nameTF.enabled = false;
        self.alipayTF.enabled = false;
        [self.bindBtn setBackgroundColor:RGB(246, 30, 46)];
        self.bindBtn.enabled = true;
        [self.pincodeView removeFromSuperview];
        [self.bindBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
    } else {
        self.nameTF.enabled = true;
        self.alipayTF.enabled = true;
        self.navigationItem.title = @"支付宝绑定";
        [self.bindBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    if (![NSString isTextEmpty:[TXModelAchivar getUserModel].aliAccount]) {
        self.nameTF.text = [TXModelAchivar getUserModel].aliName;
    }
    if (![NSString isTextEmpty:[TXModelAchivar getUserModel].aliName]) {
        self.alipayTF.text = [TXModelAchivar getUserModel].aliAccount;
    }
}

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.isBind == false) {
        if (self.nameTF.text.length != 0 &&
            self.alipayTF.text.length != 0 &&
            self.pincodeTF.text.length != 0) {
            self.bindBtn.enabled = true;
            [self.bindBtn setBackgroundColor:RGB(246, 30, 46)];
        } else {
            self.bindBtn.enabled = false;
            [self.bindBtn setBackgroundColor:RGB(153, 153, 153)];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchBindAlipayBtn:(id)sender {
    if (!self.isBind) {
        if (![NSString checkUserName:self.nameTF.text]) {
            [ShowMessage showMessage:@"请输入正确的联系人"];
            return;
        }
        
        if (![NSString checkUserName:self.pincodeTF.text]) {
            [ShowMessage showMessage:@"请输入正确的验证码"];
            return;
        }
        
        if (![NSString isPhoneNumCorrectPhoneNum:self.alipayTF.text] && ![NSString validateEmail:self.alipayTF.text]) {
            [ShowMessage showMessage:@"请输入正确的支付宝手机/邮箱账号"];
            return;
        }
        
        if (![[TXUserModel defaultUser] userLoginStatus]) {
            [ShowMessage showMessage:@"请登录"];
            return;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:bindAplipay] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:@{@"name" : self.nameTF.text, @"account" : self.alipayTF.text, @"code" : self.pincodeTF.text} success:^(AFHTTPSessionManager *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view];
            if ([responseObject[@"status"] integerValue] == 1) {
                [ShowMessage showMessage:@"绑定成功"];
                [TXModelAchivar updateUserModelWithKey:@"aliAccount" value:self.alipayTF.text];
                [TXModelAchivar updateUserModelWithKey:@"aliName" value:self.nameTF.text];
                [self.navigationController popViewControllerAnimated:true];
            } else {
                [ShowMessage showMessage:responseObject[@"msg"]];
            }
        } failure:^(AFHTTPSessionManager *operation, NSError *error) {
            [ShowMessage showMessage:error.description];
            [MBProgressHUD hideHUDForView:self.view];
        }];
    } else {
        weakSelf(self);
        UIAlertController *vwcAlert = [UIAlertController alertControllerWithTitle:@"确定解绑" message:@"您确定要解除支付宝绑定吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf disbindAlipay];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf dismissViewControllerAnimated:true completion:nil];
        }];
        
        [vwcAlert addAction:sureAction];
        [vwcAlert addAction:cancelAction];
        
        [self presentViewController:vwcAlert animated:true completion:nil];
    }
}

- (void)disbindAlipay {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:unBindAplipay] headParams:nil bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"status"] integerValue] == 1) {
            [ShowMessage showMessage:@"解绑成功"];
            [TXModelAchivar updateUserModelWithKey:@"aliAccount" value:@""];
            [TXModelAchivar updateUserModelWithKey:@"aliName" value:@""];
            [self.navigationController popViewControllerAnimated:true];
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}


- (IBAction)touchPincodeButton:(id)sender {

    
    [[TXCountDownTime sharedTXCountDownTime] startWithTime:60 title:@"获取验证码" countDownTitle:@"重新获取" mainColor:RGB(246, 30, 46) countColor:[UIColor lightGrayColor] atBtn:self.getPinBtn];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[TXModelAchivar getUserModel].account forKey:@"phone"];
    [param setValue:@"3" forKey:@"type"];

    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:pincodeMsg] headParams:nil bodyParams:param success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        [ShowMessage showMessage:responseObject[@"msg"]];
        if ([responseObject[@"status"] integerValue] == 1) {
            [ShowMessage showMessage:@"请查看手机短信"];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}


@end
