//
//  DTGoodsDescTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2018/1/14.
//  Copyright © 2018年 RogerChen. All rights reserved.
//

#import "DTGoodsDescTableViewCell.h"

@interface DTGoodsDescTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;

@property (weak, nonatomic) IBOutlet UILabel *threeLabel;

@end

@implementation DTGoodsDescTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(DTDescsModel *)model {
    _model = model;
    
    self.oneLabel.text = model.firstParam;
    self.twoLabel.text = model.twoParam;
    self.threeLabel.text = model.threeParam;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTGoodsDescTableViewCell";
    DTGoodsDescTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

@end
