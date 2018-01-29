//
//  DTCartViewTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTRestaurantModel.h"

@protocol DTCartViewTableViewCellDelegate <NSObject>

- (void)touchMinusButtonWithModel:(DTTypeModel *)model;

- (void)touchPlusButtonWithModel:(DTTypeModel *)model;

@end

@interface DTCartViewTableViewCell : TXSeperateLineCell

/** <#description#> */
@property (nonatomic, weak) id <DTCartViewTableViewCellDelegate>delegate;
@property (nonatomic, strong) DTTypeModel *model;
@property (nonatomic, strong) NSMutableDictionary *cartObjectDictionary;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
