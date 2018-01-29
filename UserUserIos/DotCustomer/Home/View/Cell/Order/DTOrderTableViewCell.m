//
//  DTOrderTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/11.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTOrderTableViewCell.h"

@interface DTOrderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsIamgeView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@property (weak, nonatomic) IBOutlet UIButton *minusBtn;

@property (weak, nonatomic) IBOutlet UIButton *plusBnt;
@end

@implementation DTOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTOrderTableViewCell";
    DTOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (void)setModel:(DTTypeModel *)model {
    _model = model;
    
    [self.goodsIamgeView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:model.img]] placeholderImage:[UIImage imageNamed:@"goods"]];
    self.nameLabel.text = model.name;
    self.subNameLabel.text = model.title;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.curPrice];
    
}

- (IBAction)touchMinusBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchMinusButtonWithModel:)]) {
        [self.delegate touchMinusButtonWithModel:self.model];
    }
}

- (IBAction)touchPlusBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchPlusButtonWithModel:)]) {
        [self.delegate touchPlusButtonWithModel:self.model];
    }
}



@end
