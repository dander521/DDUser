//
//  DTOrderListTableViewCell.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/16.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTOrderListTableViewCell.h"

@interface DTOrderListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *paybackLabel;
@property (weak, nonatomic) IBOutlet UILabel *paybackDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *productsCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@end

@implementation DTOrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.firstBtn.layer.borderColor = RGB(246, 30, 46).CGColor;
    self.firstBtn.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(DTOrderListModel *)model {
    _model = model;
    
    DTOrderModel *orderModel = model.list.firstObject;
    
    if ([model.status integerValue] == 2) {
        if ([model.assessFlag integerValue] == 0) {
            self.cellType = DTOrderListTableViewCellTypeDone;
        } else {
            self.cellType = DTOrderListTableViewCellTypeCommented;
        }
    } else if ([model.status integerValue] == 3) {
        self.cellType = DTOrderListTableViewCellTypeAppeal;
    } else if ([model.status integerValue] == 5) {
        // 退款中
        self.cellType = DTOrderListTableViewCellTypeRefund;
    } else {
        self.cellType = [model.status integerValue] + 1;
    }
    
    if ([model.orderType integerValue] == 3 && [model.status integerValue] == 2) {
        self.cellType = DTOrderListTableViewCellTypeBuyOrder;
    } else if ([model.orderType integerValue] == 3 && [model.status integerValue] == 3) {
        self.cellType = DTOrderListTableViewCellTypeAppeal;
    }
    
    if ([model.orderType integerValue] == 2) {
        self.goodsName.text = orderModel.name;
        self.productsCountLabel.text = @"";
        self.goodsImageView.image = [UIImage imageNamed:@"Group"];
    } else if ([model.orderType integerValue] == 1) {
        if (model.list.count == 1) {
            self.goodsName.text = orderModel.name;
            self.productsCountLabel.text = @"";
        } else {
            self.goodsName.text = [NSString stringWithFormat:@"%@等%zd件商品", orderModel.name, model.list.count];
            self.productsCountLabel.text = [NSString stringWithFormat:@"共%zd件商品", model.list.count];
        }
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:orderModel.img]] placeholderImage:[UIImage imageNamed:@"goods"]];
    } else {
        self.goodsName.text = [NSString stringWithFormat:@"%@买单", model.shopName];
        self.productsCountLabel.text = @"";
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:orderModel.img]] placeholderImage:[UIImage imageNamed:@"goods"]];
    }
    
    self.payTimeLabel.text = model.time;
    self.paybackLabel.text = [NSString stringWithFormat:@"%.2f", [model.orderPrice floatValue]];
    
    
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTOrderListTableViewCell";
    DTOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (void)setCellType:(DTOrderListTableViewCellType)cellType {
    _cellType = cellType;
    
    switch (cellType) {
        case DTOrderListTableViewCellTypeAll:
        {
            
        }
            break;
            
        case DTOrderListTableViewCellTypeForPay:
        {
            self.goodsCountLabel.text = @"待付款";
            [self.firstBtn setTitle:@"取消" forState:UIControlStateNormal];
            [self.secondBtn setTitle:@"付款" forState:UIControlStateNormal];
        }
            break;
            
        case DTOrderListTableViewCellTypeForUse:
        {
            self.goodsCountLabel.text = @"待使用";
            [self.firstBtn setTitle:@"退款" forState:UIControlStateNormal];
            [self.secondBtn setTitle:@"使用" forState:UIControlStateNormal];
        }
            break;
            
        case DTOrderListTableViewCellTypeDone:
        {
            self.goodsCountLabel.text = @"已完成";
            [self.firstBtn setTitle:@"申诉" forState:UIControlStateNormal];
            [self.secondBtn setTitle:@"评价" forState:UIControlStateNormal];
        }
            break;
            
        case DTOrderListTableViewCellTypeCommented:
        {
            self.goodsCountLabel.text = @"已完成";
            [self.firstBtn setTitle:@"申诉" forState:UIControlStateNormal];
            [self.secondBtn setTitle:@"查看评价" forState:UIControlStateNormal];
        }
            break;
            
        case DTOrderListTableViewCellTypeAppeal:
        {
            self.goodsCountLabel.text = @"申诉中";
            self.firstBtn.hidden = true;
            [self.secondBtn setTitle:@"取消申诉" forState:UIControlStateNormal];
        }
            break;
            
        case DTOrderListTableViewCellTypeRefund: {
            self.goodsCountLabel.text = @"已退款";
            self.firstBtn.hidden = true;
            [self.secondBtn setTitle:@"已退款" forState:UIControlStateNormal];
        }
            break;
            
        case DTOrderListTableViewCellTypeAppealSuccess: {
            self.goodsCountLabel.text = @"申诉成功";
            self.firstBtn.hidden = true;
            [self.secondBtn setTitle:@"申诉成功" forState:UIControlStateNormal];
        }
            break;
            
        case DTOrderListTableViewCellTypeBuyOrder:
        {
            self.goodsCountLabel.text = @"已完成";
            self.firstBtn.hidden = true;
            [self.secondBtn setTitle:@"申诉" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)touchFirstBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchTicketVerifyButtonWithType:model:)]) {
        [self.delegate touchTicketVerifyButtonWithType:self.cellType model:self.model];
    }
}

- (IBAction)touchSecondBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchActionButtonWithType:model:)]) {
        [self.delegate touchActionButtonWithType:self.cellType model:self.model];
    }
}

@end
