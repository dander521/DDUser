//
//  DTGoodsCommentTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/10.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTCommentModel.h"

@interface DTGoodsCommentTableViewCell : TXSeperateLineCell

@property (nonatomic, strong) DTCommentModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
