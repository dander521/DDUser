//
//  DTTicketOperateTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTTicketOperateTableViewCell.h"

@interface DTTicketOperateTableViewCell ()
    

    
    
@end

@implementation DTTicketOperateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTTicketOperateTableViewCell";
    DTTicketOperateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}
    
- (IBAction)touchMinusBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchMinusButton)]) {
        [self.delegate touchMinusButton];
    }
}
    
- (IBAction)touchPlusBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchPlusButton)]) {
        [self.delegate touchPlusButton];
    }
}
    

@end
