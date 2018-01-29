//
//  DTRestaurantDetailGoodsTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/10.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTRestaurantModel.h"

@protocol DTRestaurantDetailGoodsTableViewCellDelegate <NSObject>

- (void)touchAddGoodsButtonWithModel:(DTTypeModel *)model;

@end

@interface DTRestaurantDetailGoodsTableViewCell : TXSeperateLineCell

/** <#description#> */
@property (nonatomic, strong) DTTypeModel *model;
@property (nonatomic, assign) id<DTRestaurantDetailGoodsTableViewCellDelegate>delegate;
/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
