//
//  DTNotificationTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/29.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTNotificationTableViewCell.h"

@interface DTNotificationTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *dotLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation DTNotificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dotLabel.layer.cornerRadius = 3.5;
    self.dotLabel.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(DTNotificationModel *)model {
    _model = model;
    
    self.typeLabel.text = model.title;
    self.orderNoLabel.text = model.time;
    if ([model.orderStatus integerValue] == 2) {
        self.dotLabel.backgroundColor = RGB(153, 153, 153);
    } else {
        self.dotLabel.backgroundColor = RGB(247, 30, 46);
    }
    
    if ([model.type isEqualToString:@"2"]) {
        DTNotificationSubModel *subModel = model.list.firstObject;
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:subModel.img]] placeholderImage:[UIImage imageNamed:@"goods"]];
        
        self.nameLabel.text = model.list.count == 1 ? subModel.name : [NSString stringWithFormat:@"%@等%zd件商品", subModel.name, model.list.count];
        self.numLabel.text = [NSString stringWithFormat:@"x%zd", [subModel.num integerValue]];
        self.timeLabel.text = [NSString stringWithFormat:@"下单时间：%@", model.time];
    } else {
        self.timeLabel.text = model.content;
        self.nameLabel.text = model.title;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTNotificationTableViewCell";
    DTNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

@end
