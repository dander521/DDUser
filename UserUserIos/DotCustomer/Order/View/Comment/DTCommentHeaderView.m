//
//  DTCommentHeaderView.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/29.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTCommentHeaderView.h"

@interface DTCommentHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopName;

@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation DTCommentHeaderView

+ (instancetype)instanceView {
    DTCommentHeaderView *customView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    
    return customView;
}

- (void)setModel:(DTOrderListModel *)model {
    _model = model;
    
    DTOrderModel *orderModel = model.list.firstObject;
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:orderModel.img]] placeholderImage:[UIImage imageNamed:@"goods"]];
    self.shopName.text = model.shopName;
    self.goodsName.text = model.list.count == 1 ? orderModel.name : [NSString stringWithFormat:@"%@等%zd件商品", orderModel.name, model.list.count];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [model.orderPrice floatValue]];
    self.timeLabel.text = [NSString stringWithFormat:@"下单时间：%@", model.time];
}

@end
