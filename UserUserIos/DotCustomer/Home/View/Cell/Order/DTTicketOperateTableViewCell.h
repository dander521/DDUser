//
//  DTTicketOperateTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTTicketOperateTableViewCellDelegate <NSObject>
    
- (void)touchMinusButton;
    
- (void)touchPlusButton;
    
@end

@interface DTTicketOperateTableViewCell : TXSeperateLineCell

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic, weak) id <DTTicketOperateTableViewCellDelegate> delegate;
    
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
