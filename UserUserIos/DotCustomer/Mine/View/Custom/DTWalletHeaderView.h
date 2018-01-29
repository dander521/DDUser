//
//  DTWalletHeaderView.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTWalletHeaderViewDelegate <NSObject>

- (void)touchWithdrawButton;

@end

@interface DTWalletHeaderView : UIView

@property (assign, nonatomic) id <DTWalletHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

/**
 *  实例方法
 */
+ (instancetype)instanceView;

@end
