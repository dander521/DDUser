//
//  DTCartViewTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTCartViewTableViewCell.h"

@interface DTCartViewTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation DTCartViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTCartViewTableViewCell";
    DTCartViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
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

- (void)setCartObjectDictionary:(NSMutableDictionary *)cartObjectDictionary {
    _cartObjectDictionary = cartObjectDictionary;
    
    self.countLabel.text = [cartObjectDictionary objectForKey:self.model.idField];
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %.2f", [self.model.curPrice floatValue]];
}

- (void)setModel:(DTTypeModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
}

@end
