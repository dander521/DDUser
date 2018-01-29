//
//  DTWalletTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/29.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTWalletTableViewCell.h"

@interface DTWalletTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation DTWalletTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(DTWalletModel *)model {
    _model = model;
    // (1退款2提现申请3提现失败4商品购买5红包红利)
    
    NSString *typeName = nil;
    switch ([model.type integerValue]) {
        case 1:{
            typeName = @"退款";
        }
            break;
        case 2:{
            typeName = @"提现申请";
        }
            break;
        case 3:{
            typeName = @"提现失败";
        }
            break;
        case 4:{
            typeName = @"商品购买";
        }
            break;
        case 5:{
            typeName = @"员工股退购";
        }
            break;
        case 6:{
            typeName = @"红包红利";
        }
            break;
            
        default:
            typeName = @"未知类型";
            break;
    }
    self.nameLabel.text = typeName;
    self.timeLabel.text = model.time;
    if ([model.changeType isEqualToString:@"1"]) {
        self.countLabel.text = [NSString stringWithFormat:@"-%@", model.money];
        self.countLabel.textColor = RGB(246, 30, 46);
    } else {
        self.countLabel.text = [NSString stringWithFormat:@"+%@", model.money];
        self.countLabel.textColor = RGB(153, 153, 153);
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTWalletTableViewCell";
    DTWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

@end
