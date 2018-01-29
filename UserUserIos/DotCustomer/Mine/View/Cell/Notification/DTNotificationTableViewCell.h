//
//  DTNotificationTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/29.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTNotificationModel.h"

@interface DTNotificationTableViewCell : TXSeperateLineCell

/** <#description#> */
@property (nonatomic, strong) DTNotificationModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
