//
//  DTPersonAvatarTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/22.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTPersonAvatarTableViewCell : TXSeperateLineCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end