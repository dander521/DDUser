//
//  DTGoodsDetailCartTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/10.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTGoodsDetailCartTableViewCell.h"

@interface DTGoodsDetailCartTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *subNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (weak, nonatomic) IBOutlet UILabel *usePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *cartLabel;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;


@end

@implementation DTGoodsDetailCartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTGoodsDetailCartTableViewCell";
    DTGoodsDetailCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (IBAction)touchMinusBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchMinusToCartButtonWithModel:)]) {
        [self.delegate touchMinusToCartButtonWithModel:self.typeModel];
    }
}

- (IBAction)touchPlusBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchPlusToCartButtonWithModel:)]) {
        [self.delegate touchPlusToCartButtonWithModel:self.typeModel];
    }
}

- (IBAction)touchAddToCartBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchAddToCartButtonWithModel:)]) {
        [self.delegate touchAddToCartButtonWithModel:self.typeModel];
    }
}

- (void)setIsHiddenBuyLabel:(BOOL)isHiddenBuyLabel {
    _isHiddenBuyLabel = isHiddenBuyLabel;
    if (isHiddenBuyLabel) {
        self.cartLabel.hidden = true;
        self.plusBtn.hidden = false;
        self.minusBtn.hidden = false;
        self.countLabel.hidden = false;
    } else {
        self.cartLabel.hidden = false;
        self.plusBtn.hidden = true;
        self.minusBtn.hidden = true;
        self.countLabel.hidden = true;
    }
}

- (void)setGoodsModel:(DTGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    
    self.nameLabel.text = goodsModel.name;
    self.subNameLabel.text = goodsModel.title;
    self.saleLabel.text = [NSString stringWithFormat:@"月销%@", goodsModel.saleNum];
    self.usePriceLabel.text = [NSString stringWithFormat:@"￥%@", goodsModel.curPrice];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", goodsModel.price];
}

@end
