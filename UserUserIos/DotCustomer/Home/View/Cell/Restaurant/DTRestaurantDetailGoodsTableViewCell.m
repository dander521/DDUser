//
//  DTRestaurantDetailGoodsTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/10.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTRestaurantDetailGoodsTableViewCell.h"

@interface DTRestaurantDetailGoodsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsSubName;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end

@implementation DTRestaurantDetailGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(DTTypeModel *)model {
    _model = model;
    NSArray *imageArray = [model.img componentsSeparatedByString:@","];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:imageArray.firstObject]] placeholderImage:[UIImage imageNamed:@"goods"]];
    self.goodsName.text = model.name;
    self.goodsSubName.text = model.title;
    self.saleLabel.text = [NSString stringWithFormat:@"月销%@", model.saleNum];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.curPrice];
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTRestaurantDetailGoodsTableViewCell";
    DTRestaurantDetailGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}
- (IBAction)touchAddGoodsBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchAddGoodsButtonWithModel:)]) {
        [self.delegate touchAddGoodsButtonWithModel:self.model];
    }
}

@end
