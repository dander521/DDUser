//
//  DTRestaurantGoodsTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/10.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTRestaurantModel.h"

@protocol DTRestaurantGoodsTableViewCellDelegate <NSObject>

- (void)touchGoodsDetailCellWithModel:(DTTypeModel *)model;

- (void)touchGoodsDetailAddButtonWithModel:(DTTypeModel *)model;

@end

@interface DTRestaurantGoodsTableViewCell : TXSeperateLineCell

/** <#description#> */
@property (nonatomic, strong) DTRestaurantModel *model;
@property (nonatomic, assign) id<DTRestaurantGoodsTableViewCellDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
