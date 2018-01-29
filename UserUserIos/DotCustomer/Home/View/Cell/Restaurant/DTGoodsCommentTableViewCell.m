//
//  DTGoodsCommentTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/10.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTGoodsCommentTableViewCell.h"

@interface DTGoodsCommentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation DTGoodsCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTGoodsCommentTableViewCell";
    DTGoodsCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (void)setModel:(DTCommentModel *)model {
    _model = model;
    
    [self.commentImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:model.img]] placeholderImage:[UIImage imageNamed:@"goods"]];
    self.nameLabel.text = model.name;
    self.contentLabel.text = model.content;
    self.timeLabel.text = model.time;
}

@end
