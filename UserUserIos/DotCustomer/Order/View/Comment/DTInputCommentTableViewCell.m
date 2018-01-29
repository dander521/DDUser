//
//  DTInputCommentTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/29.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTInputCommentTableViewCell.h"

@implementation DTInputCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.starView = [[XHStarRateView alloc]initWithFrame:CGRectMake(80, 15, SCREEN_WIDTH - 160, 34) numberOfStars:5 rateStyle:WholeStar isAnination:NO finish:nil];
    self.starView.currentScore = 5;
    self.starView.delegate = self;
    self.starView.userInteractionEnabled = true;
    [self.starBgView addSubview:self.starView];
}

-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore {
    if ([self.delegate respondsToSelector:@selector(starRateView:currentScore:)]) {
        [self.delegate starRateView:starRateView currentScore:currentScore];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTInputCommentTableViewCell";
    DTInputCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

@end
