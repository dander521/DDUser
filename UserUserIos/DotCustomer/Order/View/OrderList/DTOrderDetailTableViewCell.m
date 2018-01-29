//
//  DTOrderDetailTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTOrderDetailTableViewCell.h"

@interface DTOrderDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNameLabel;

@end

@implementation DTOrderDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(DTOrderModel *)model {
    _model = model;
    
    if ([self.orderType integerValue] == 1 || [self.orderType integerValue] == 3) {
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:model.img]] placeholderImage:[UIImage imageNamed:@"goods"]];
    } else {
        self.goodsImageView.image = [UIImage imageNamed:@"Group"];
    }
    
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [model.price floatValue]];
    self.saleLabel.text = [NSString stringWithFormat:@"x%@", model.num];
    self.subNameLabel.text = model.title;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTOrderDetailTableViewCell";
    DTOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

@end
