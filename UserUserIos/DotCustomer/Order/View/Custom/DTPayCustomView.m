//
//  DTPayCustomView.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTPayCustomView.h"

@implementation DTPayCustomView

+ (instancetype)shareInstanceManager {
    DTPayCustomView *instance = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    
    instance.payType = DTPayCustomViewPayTypeBalance;
    [instance.balanceBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    [instance.wechatBtn setImage:[UIImage imageNamed:@"ic_unselected"] forState:UIControlStateNormal];
    [instance.aliBtn setImage:[UIImage imageNamed:@"ic_unselected"] forState:UIControlStateNormal];
    
    return instance;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        //代码
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestrueMethod:)];
        tapGesture.delegate = self;
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}

// 点击背景
- (void)tapGestrueMethod:(UITapGestureRecognizer *)gesture {
    [self hide];
}

- (void)show {
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

// 添加弹出移除的动画效果
- (void)showInView:(UIView *)view {
    self.backgroundColor = RGBA(0, 0, 0, 0.3);
    [view addSubview:self];
}

- (void)hide {
    self.backgroundColor = RGBA(0, 0, 0, 0.0);
    [self removeFromSuperview];
}

- (IBAction)touchCloseBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchCloseViewButton)]) {
        [self.delegate touchCloseViewButton];
    }
    [self hide];
}

- (IBAction)touchBalanceBtn:(id)sender {
    self.payType = DTPayCustomViewPayTypeBalance;
}

- (IBAction)touchWechatBtn:(id)sender {
    self.payType = DTPayCustomViewPayTypeWechat;
}

- (IBAction)touchAliBtn:(id)sender {
    self.payType = DTPayCustomViewPayTypeAli;
}

- (IBAction)touchCommitBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchPayBtnWithPayType:model:)]) {
        [self.delegate touchPayBtnWithPayType:self.payType model:self.listModel];
    }
}

- (void)setListModel:(DTOrderListModel *)listModel {
    _listModel = listModel;
    
}

- (void)setPayType:(DTPayCustomViewPayType)payType {
    _payType = payType;
    
    if (payType == DTPayCustomViewPayTypeBalance) {
        [self.balanceBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        [self.wechatBtn setImage:[UIImage imageNamed:@"ic_unselected"] forState:UIControlStateNormal];
        [self.aliBtn setImage:[UIImage imageNamed:@"ic_unselected"] forState:UIControlStateNormal];
    } else if (payType == DTPayCustomViewPayTypeWechat) {
        [self.balanceBtn setImage:[UIImage imageNamed:@"ic_unselected"] forState:UIControlStateNormal];
        [self.wechatBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        [self.aliBtn setImage:[UIImage imageNamed:@"ic_unselected"] forState:UIControlStateNormal];
    } else {
        [self.balanceBtn setImage:[UIImage imageNamed:@"ic_unselected"] forState:UIControlStateNormal];
        [self.wechatBtn setImage:[UIImage imageNamed:@"ic_unselected"] forState:UIControlStateNormal];
        [self.aliBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    }
}



@end
