//
//  DTRestaurantCategoryTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/10.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTRestaurantCategoryTableViewCell : TXSeperateLineCell
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
