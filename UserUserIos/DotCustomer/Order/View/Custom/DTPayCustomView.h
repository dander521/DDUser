//
//  DTPayCustomView.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTOrderListModel.h"

typedef NS_ENUM(NSInteger, DTPayCustomViewPayType) {
    DTPayCustomViewPayTypeBalance,
    DTPayCustomViewPayTypeAli,
    DTPayCustomViewPayTypeWechat
};

@protocol DTPayCustomViewDelegate <NSObject>

- (void)touchPayBtnWithPayType:(DTPayCustomViewPayType)type model:(DTOrderListModel *)model;

- (void)touchCloseViewButton;

@end

@interface DTPayCustomView : UIView<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *aliBtn;

/** <#description#> */
@property (nonatomic, strong) DTOrderListModel *listModel;

@property (assign, nonatomic) id <DTPayCustomViewDelegate> delegate;

@property (nonatomic, assign) DTPayCustomViewPayType payType;

+ (instancetype)shareInstanceManager;

- (void)show;

- (void)hide;

@end
