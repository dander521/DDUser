//
//  DTGoodsDetailsTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2018/1/25.
//  Copyright © 2018年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTGoodsDetailsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
