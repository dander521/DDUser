//
//  DTSearchTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/11.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTSearchTableViewCell.h"

@interface DTSearchTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation DTSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTSearchTableViewCell";
    DTSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (void)setModel:(DTSearchResultProductsModel *)model {
    _model = model;
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:model.img]] placeholderImage:[UIImage imageNamed:@"goods"]];
    self.nameLabel.text = model.name;
    self.titleLabel.text = model.title;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.curPrice];
    self.saleLabel.text = [NSString stringWithFormat:@"月售%@", model.saleNum];
}

@end
