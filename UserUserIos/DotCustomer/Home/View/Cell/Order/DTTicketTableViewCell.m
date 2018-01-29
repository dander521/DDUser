//
//  DTTicketTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTTicketTableViewCell.h"

@implementation DTTicketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTTicketTableViewCell";
    DTTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

@end
