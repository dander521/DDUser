//
//  DTRedPacketViewController.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTRedPacketViewController.h"

@interface DTRedPacketViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *bgHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgHeaderViewHeightLayout;

@property (assign, nonatomic) BOOL isSave;

@end

@implementation DTRedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"红包详情";
    self.isSave = false;
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", [self.redpacketNum floatValue]];
    self.desLabel.text = [NSString stringWithFormat:@"%@给你发了一个红包", self.model.shopName];
    self.headerImageView.layer.cornerRadius = 45;
    self.headerImageView.layer.masksToBounds = true;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:self.model.shopIcon]] placeholderImage:[UIImage imageNamed:@"user"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)touchSureBtn:(id)sender {
    if (!self.isSave) {
        [UIView animateWithDuration:1.0 animations:^{
            self.moneyLabel.hidden = false;
            self.desLabel.text = @"已存入钱包";
            [self.sureBtn setTitle:@"完成" forState:UIControlStateNormal];
            self.bgViewTopLayout.constant = 180;

            self.bgImageView.image = [UIImage imageNamed:@"hongbao_dakai"];
            [self.view layoutIfNeeded];
        }];
        self.isSave = true;
    } else {
        [self.navigationController popToRootViewControllerAnimated:true];
    }
}

@end
