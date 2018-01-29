//
//  DTGoodsDetailsTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2018/1/25.
//  Copyright © 2018年 RogerChen. All rights reserved.
//

#import "DTGoodsDetailsTableViewCell.h"

@implementation DTGoodsDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTGoodsDetailsTableViewCell";
    DTGoodsDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

@end
