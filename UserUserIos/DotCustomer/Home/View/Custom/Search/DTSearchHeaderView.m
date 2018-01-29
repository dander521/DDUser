//
//  DTSearchHeaderView.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/11.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTSearchHeaderView.h"
#import "XHStarRateView.h"

@interface DTSearchHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@property (strong, nonatomic) XHStarRateView *starView;
@property (weak, nonatomic) IBOutlet UIView *starBgView;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UILabel *deliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel *paperLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;

@end

@implementation DTSearchHeaderView

+ (instancetype)instanceView {
    DTSearchHeaderView *customView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    
    customView.rewardLabel.layer.cornerRadius = 3;
    customView.rewardLabel.layer.masksToBounds = true;
    customView.rewardLabel.layer.borderColor = RGB(255, 146, 19).CGColor;
    customView.rewardLabel.layer.borderWidth = 1;
    
    [customView.starBgView addSubview:customView.starView];
    return customView;
}

- (XHStarRateView *)starView {
    if (!_starView) {
        _starView = [[XHStarRateView alloc]initWithFrame:CGRectMake(0, 0, 80, 15) numberOfStars:5 rateStyle:WholeStar isAnination:NO finish:nil];
        _starView.currentScore = 5;
        _starView.userInteractionEnabled = NO;
    }
    return _starView;
}
- (IBAction)touchHeaderBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchHeaderViewButtonWithModel:)]) {
        [self.delegate touchHeaderViewButtonWithModel:self.model];
    }
}

- (void)setModel:(DTSearchResultModel *)model {
    _model = model;
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:model.minIcon]] placeholderImage:[UIImage imageNamed:@"goods"]];
    self.storeNameLabel.text = model.name;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@km", model.distance];
    self.starView.currentScore = [model.score floatValue];
    
    if ([model.dispatchFlag integerValue] == 0) {
//        [self.deliveryLabel removeFromSuperview];
        self.deliveryLabel.hidden = true;
    }
    
    if ([model.paperStatus integerValue] == 0) {
//        [self.paperLabel removeFromSuperview];
        self.paperLabel.hidden = true;
    }
    
    if ([model.type integerValue] == 1) {
        self.rewardLabel.text = [NSString stringWithFormat:@"红包%@%%", model.rate];
    } else {
        self.rewardLabel.text = [NSString stringWithFormat:@"红包%@%%", model.maxRate];
    }
    
    self.saleLabel.text = [NSString stringWithFormat:@"月售%@", model.salerNum];
}

@end
