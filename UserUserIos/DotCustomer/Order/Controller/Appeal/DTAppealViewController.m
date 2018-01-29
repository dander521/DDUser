//
//  DTAppealViewController.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/29.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTAppealViewController.h"

@interface DTAppealViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *appealTF;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation DTAppealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申诉";
    [self.appealTF addPlaceholderWithText:@"请填写您要申诉的内容" textColor:[UIColor lightGrayColor] font:[UIFont fontWithName:@"Helvetica-Light" size:16]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textViewDidChanged:(NSNotification *)noti {
    if (self.appealTF.text.length != 0) {
        self.commitButton.enabled = true;
        [self.commitButton setBackgroundColor:RGB(246, 30, 46)];
    } else {
        self.commitButton.enabled = false;
        [self.commitButton setBackgroundColor:RGB(153, 153, 153)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)touchCommitBtn:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.appealTF.text forKey:@"content"];
    [params setValue:self.orderId forKey:@"orderId"];
    
    NSMutableDictionary *headerParams = [NSMutableDictionary new];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:orderComplaint] headParams:headerParams bodyParams:params success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if ([responseObject[@"status"] integerValue] == 1) {
            [ShowMessage showMessage:@"申诉成功"];
            [self.navigationController popViewControllerAnimated:true];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationAppealSuccess object:nil userInfo:nil];
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [ShowMessage showMessage:error.description];
    }];
}

@end
