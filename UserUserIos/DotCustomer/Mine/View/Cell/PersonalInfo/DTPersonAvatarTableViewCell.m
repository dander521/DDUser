//
//  DTPersonAvatarTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/22.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTPersonAvatarTableViewCell.h"

@implementation DTPersonAvatarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarImageView.layer.cornerRadius = 30;
    self.avatarImageView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTPersonAvatarTableViewCell";
    DTPersonAvatarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

@end
