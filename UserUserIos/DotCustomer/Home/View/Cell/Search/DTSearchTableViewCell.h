//
//  DTSearchTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/11.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSearchResultModel.h"

@interface DTSearchTableViewCell : TXSeperateLineCell

/** <#description#> */
@property (nonatomic, strong) DTSearchResultProductsModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
