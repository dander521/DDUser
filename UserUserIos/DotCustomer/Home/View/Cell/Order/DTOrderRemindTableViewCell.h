//
//  DTOrderRemindTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/11.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTOrderRemindTableViewCell : TXSeperateLineCell

@property (weak, nonatomic) IBOutlet UITextView *contentTX;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
