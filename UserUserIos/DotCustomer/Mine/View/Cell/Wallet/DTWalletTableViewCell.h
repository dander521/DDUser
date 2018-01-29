//
//  DTWalletTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/29.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTWalletModel.h"

@interface DTWalletTableViewCell : TXSeperateLineCell

/** <#description#> */
@property (nonatomic, strong) DTWalletModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
