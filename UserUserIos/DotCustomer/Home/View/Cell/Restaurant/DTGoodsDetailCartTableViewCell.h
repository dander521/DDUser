//
//  DTGoodsDetailCartTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/10.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTRestaurantModel.h"
#import "DTGoodsModel.h"

@protocol DTGoodsDetailCartTableViewCellDelegate <NSObject>

- (void)touchAddToCartButtonWithModel:(DTTypeModel *)model;

- (void)touchPlusToCartButtonWithModel:(DTTypeModel *)model;

- (void)touchMinusToCartButtonWithModel:(DTTypeModel *)model;

@end

@interface DTGoodsDetailCartTableViewCell : TXSeperateLineCell

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) DTTypeModel *typeModel;
@property (nonatomic, strong) DTGoodsModel *goodsModel;
@property (nonatomic, assign) BOOL isHiddenBuyLabel;
@property (assign, nonatomic) id <DTGoodsDetailCartTableViewCellDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
