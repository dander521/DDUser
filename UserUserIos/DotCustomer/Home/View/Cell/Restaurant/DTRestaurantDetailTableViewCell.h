//
//  DTRestaurantDetailTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/10.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTRestaurantModel.h"
@class DTCouponModel;

@protocol DTRestaurantDetailTableViewCellDelegate <NSObject>

- (void)touchPhoneNoButton;

- (void)touchBuyTicketButtonWithModel:(DTCouponModel *)model;

- (void)touchBuyOrderButton;

- (void)touchAddressButton;

@end

@interface DTRestaurantDetailTableViewCell : TXSeperateLineCell

/** <#description#> */
@property (nonatomic, strong) DTRestaurantModel *model;
@property (nonatomic, assign) id<DTRestaurantDetailTableViewCellDelegate>delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
