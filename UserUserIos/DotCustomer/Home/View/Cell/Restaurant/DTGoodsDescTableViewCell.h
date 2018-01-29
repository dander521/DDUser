//
//  DTGoodsDescTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2018/1/14.
//  Copyright © 2018年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTGoodsModel.h"

@interface DTGoodsDescTableViewCell : UITableViewCell

/** <#description#> */
@property (nonatomic, strong) DTDescsModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
