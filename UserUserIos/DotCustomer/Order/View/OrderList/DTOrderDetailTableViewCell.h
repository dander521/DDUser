//
//  DTOrderDetailTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTOrderListModel.h"

@interface DTOrderDetailTableViewCell : TXSeperateLineCell

/** <#description#> */
@property (nonatomic, strong) DTOrderModel *model;
/** <#description#> */
@property (nonatomic, strong) NSString *orderType;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
