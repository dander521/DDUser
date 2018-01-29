//
//  DTTicketTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTTicketTableViewCell : TXSeperateLineCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
    @property (weak, nonatomic) IBOutlet UILabel *priceLabel;
    
@end
